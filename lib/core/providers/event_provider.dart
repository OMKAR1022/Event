import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;
  int _totalEvents = 0;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;
  int get totalEvents => _totalEvents; // Getter for total events count

  EventProvider() {
    _initializeRealTimeUpdates();
  }

  // Fetch events based on club ID
  Future<void> fetchEvents(String clubId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      // Fetch events for the given club ID
      final response = await supabase
          .from('events')
          .select('*')
          .eq('club_id', clubId) // Filter by club ID
          .order('start_time', ascending: true);

      final now = DateTime.now();

      _events = List<Map<String, dynamic>>.from(response).map((event) {
        final startTime = DateTime.parse(event['start_time']);
        final endTime = DateTime.parse(event['end_time']);

        // Determine event status
        if (now.isAfter(endTime)) {
          event['status'] = 'Closed';
        } else if (now.isBefore(endTime) && endTime.difference(now).inHours <= 4) {
          event['status'] = 'Closing Soon';
        } else {
          event['status'] = 'Open';
        }

        return event;
      }).toList();

      _totalEvents = _events.length; // Update the total event count

      print('Fetched Events: $_events');
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Real-time updates for events
  void _initializeRealTimeUpdates() {
    final supabase = Supabase.instance.client;

    supabase
        .from('events')
        .stream(primaryKey: ['id'])
        .listen((data) {
      if (_events.isNotEmpty) {
        fetchEvents(_events.first['club_id']); // Refresh events for the same club
      }
    });
  }
}