import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentEventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;
  int _totalEvents = 0;
  RealtimeChannel? _eventSubscription;
  RealtimeChannel? _registrationSubscription;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;
  int get totalEvents => _totalEvents;

  StudentEventProvider() {
    _initializeRealTimeUpdates();
  }

  void _initializeRealTimeUpdates() {
    final supabase = Supabase.instance.client;

    // Subscribe to events table changes
    _eventSubscription = supabase
        .channel('public:event')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'event',
      callback: (payload) {
        print('Received events update: $payload');
        fetchAllEvents();
      },
    )
        .subscribe();

    // Subscribe to event_registrations table changes
    _registrationSubscription = supabase
        .channel('public:event_registrations')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'event_registrations',
      callback: (payload) {
        print('Received registrations update: $payload');
        _updateEventRegistrations(payload);
      },
    )
        .subscribe();
  }

  Future<void> fetchAllEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('event')
          .select('*, clubs(name)')
          .order('date', ascending: true);

      _events = await Future.wait(List<Map<String, dynamic>>.from(response).map((event) async {
        final registrationCount = await _fetchRegistrationCount(event['id'].toString());
        return {
          ...event,
          'date': event['date'] != null ? DateTime.parse(event['date']).toIso8601String() : null,
          'registration_deadline': event['registration_deadline'] != null
              ? DateTime.parse(event['registration_deadline']).toIso8601String()
              : null,
          'registrations': registrationCount,
        };
      }).toList());

      _totalEvents = _events.length;
      print('Fetched Events for Students: $_events');
    } catch (e) {
      debugPrint('Error fetching events for students: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> _fetchRegistrationCount(String eventId) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('event_registrations')
          .select()
          .eq('event_id', eventId);

      return response.length;
    } catch (e) {
      debugPrint('Error fetching registration count: $e');
      return 0;
    }
  }

  void _updateEventRegistrations(PostgresChangePayload payload) async {
    String? eventId;
    if (payload.newRecord != null) {
      eventId = payload.newRecord!['event_id']?.toString();
    } else if (payload.oldRecord != null) {
      eventId = payload.oldRecord!['event_id']?.toString();
    }

    if (eventId == null) return;

    final newCount = await _fetchRegistrationCount(eventId);

    final eventIndex = _events.indexWhere((event) => event['id'].toString() == eventId);
    if (eventIndex != -1) {
      _events[eventIndex]['registrations'] = newCount;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _eventSubscription?.unsubscribe();
    _registrationSubscription?.unsubscribe();
    super.dispose();
  }
}

