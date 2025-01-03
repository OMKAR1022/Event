import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventProvider with ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;

  EventProvider() {
    // Initialize the real-time listener
    _initializeRealTimeUpdates();
  }

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      // Fetch events from the Supabase database
      final response = await supabase
          .from('events') // Table name
          .select('*') // Select all columns
          .order('start_time', ascending: true); // Order by start time

      final now = DateTime.now();

      // Update the status field based on time logic
      _events = List<Map<String, dynamic>>.from(response).map((event) {
        final startTime = DateTime.parse(event['start_time']); // Ensure proper parsing
        final endTime = DateTime.parse(event['end_time']);   // Ensure proper parsing

        if (now.isAfter(endTime)) {
          event['status'] = 'Closed'; // Event has ended
        } else if (now.isBefore(endTime) &&
            endTime.difference(now).inHours <= 4) {
          event['status'] = 'Closing Soon'; // Less than or equal to 4 hours remaining
        } else if (endTime.difference(startTime).inHours > 4) {
          event['status'] = 'Open'; // More than 4 hours difference
        }

        return event;
      }).toList();

      print('Fetched Events: $_events'); // Debug print to verify data
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _initializeRealTimeUpdates() {
    final supabase = Supabase.instance.client;

    // Set up a listener for real-time changes to the "events" table
    supabase
        .from('events') // Listen to the "events" table
        .stream(primaryKey: ['id']) // Specify the primary key of the table
        .listen((data) {
      fetchEvents(); // Re-fetch events whenever the table changes
    });
  }
}
