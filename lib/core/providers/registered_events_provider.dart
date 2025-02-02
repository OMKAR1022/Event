import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisteredEventsProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _registeredEvents = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get registeredEvents => _registeredEvents;
  bool get isLoading => _isLoading;

  Future<void> fetchRegisteredEvents(String studentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('event_registrations')
          .select('''
            event_id,
            attendance,
            event:event (
              id,
              title,
              date,
              start_time,
              end_time,
              venue,
              clubs (
                name
              )
            )
          ''')
          .eq('student_id', studentId);

      _registeredEvents = List<Map<String, dynamic>>.from(response).map((registration) {
        final event = registration['event'];
        return {
          'id': event['id'],
          'title': event['title'],
          'date': event['date'],
          'start_time': event['start_time'],
          'end_time': event['end_time'],
          'venue': event['venue'],
          'club_name': event['clubs']['name'],
          'attendance': registration['attendance'],
        };
      }).toList();

      _registeredEvents.sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateA.compareTo(dateB);
      });

    } catch (e) {
      print('Error fetching registered events: $e');
      _registeredEvents = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAttendance(String eventId, String studentId) async {
    try {
      await _supabase
          .from('event_registrations')
          .update({'attendance': 'present'})
          .eq('event_id', eventId)
          .eq('student_id', studentId);

      // Update local state
      final index = _registeredEvents.indexWhere((event) => event['id'] == eventId);
      if (index != -1) {
        _registeredEvents[index]['attendance'] = 'present';
        notifyListeners();
      }
    } catch (e) {
      print('Error marking attendance: $e');
      rethrow;
    }
  }
}

