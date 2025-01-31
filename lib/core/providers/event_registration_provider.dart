import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRegistrationProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSuccess => _isSuccess;

  Future<void> registerForEvent({
    required int eventId,
    required String studentName,
    required String email,
    required String phoneNo,
    required String enrollNo,
  }) async {
    print('Starting registration process for event $eventId');
    try {
      _isLoading = true;
      _error = null;
      _isSuccess = false;
      notifyListeners();

      final supabase = Supabase.instance.client;

      // Check if user already registered for this event
      final existingRegistrations = await supabase
          .from('event_registrations')
          .select()
          .eq('event_id', eventId)
          .eq('email', email);

      if (existingRegistrations.isNotEmpty) {
        _error = 'You have already registered for this event';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // If not registered, proceed with registration
      final response = await supabase
          .from('event_registrations')
          .insert({
        'event_id': eventId,
        'student_name': studentName,
        'email': email,
        'phone': phoneNo,
        'enroll_no': enrollNo,
      });

      // Log the response for debugging
      print('Response: $response');

      // If the response is not null and no exception is thrown, registration is successful
      _isSuccess = true;
      _isLoading = false;
      notifyListeners();
      print('Registration process completed. Success: $_isSuccess, Error: $_error');

    } catch (error) {
      _error = 'Failed to register: $error';
      _isLoading = false;
      _isSuccess = false;
      notifyListeners();
      print('Error occurred during registration: $_error');
    }
  }
  void resetState() {
    _isLoading = false;
    _error = null;
    _isSuccess = false;
    notifyListeners();
  }
}

