import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;
  int _totalEvents = 0;
  String? _currentClubId;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;
  int get totalEvents => _totalEvents;

  EventProvider() {
    _initializeRealTimeUpdates();
  }

  Future<void> fetchEvents(String clubId) async {
    if (_currentClubId == clubId && _events.isNotEmpty) {
      return; // Don't fetch if we already have events for this club
    }

    _isLoading = true;
    _events.clear();
    _currentClubId = clubId;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('event')
          .select('*')
          .eq('club_id', clubId)
          .order('date', ascending: true);

      _events = await Future.wait(List<Map<String, dynamic>>.from(response).map((event) async {
        final registrationCount = await _fetchRegistrationCount(event['id'].toString());
        return {
          ...event,
          'registrations': registrationCount,
        };
      }).toList());

      _totalEvents = _events.length;

      print('Fetched Events: $_events');
    } catch (e) {
      debugPrint('Error fetching events: $e');
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

  void _initializeRealTimeUpdates() {
    final supabase = Supabase.instance.client;

    supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      if (data.isNotEmpty && _currentClubId != null) {
        _updateEventsFromStream(data);
      }
    });
  }

  void _updateEventsFromStream(List<Map<String, dynamic>> updatedEvents) {
    for (var updatedEvent in updatedEvents) {
      int index = _events.indexWhere((event) => event['id'] == updatedEvent['id']);
      if (index != -1) {
        _events[index] = {..._events[index], ...updatedEvent};
      } else {
        _events.add(updatedEvent);
      }
    }
    _totalEvents = _events.length;
    notifyListeners();
  }
}

