import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRegistrationProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isSuccess = false;
  Map<String, bool> _registrationStatus = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSuccess => _isSuccess;

  Future<void> registerForEvent({
    required int eventId,
    required String studentId,
  }) async {
    if (studentId.isEmpty) {
      _error = 'student ID is empty';
      notifyListeners();
      return;
    }

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
          .eq('student_id', studentId);

      if (existingRegistrations.isNotEmpty) {
        _error = 'You have already registered for this event';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // If not registered, proceed with registration
      await supabase.from('event_registrations').insert({
        'event_id': eventId,
        'student_id': studentId,
      });

      _isSuccess = true;
      _registrationStatus['$eventId-$studentId'] = true;
      _isLoading = false;
      notifyListeners();
      print('Registration process completed. Success: $_isSuccess, Error: $_error');

    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      _isSuccess = false;
      notifyListeners();
      print('Error occurred during registration: $_error');
    }
  }

  Future<bool> isStudentRegistered({required int eventId, required String studentId}) async {
    if (studentId.isEmpty) {
      print('student ID is empty');
      return false;
    }

    final cacheKey = '$eventId-$studentId';
    if (_registrationStatus.containsKey(cacheKey)) {
      return _registrationStatus[cacheKey]!;
    }

    try {
      final supabase = Supabase.instance.client;
      final existingRegistrations = await supabase
          .from('event_registrations')
          .select()
          .eq('event_id', eventId)
          .eq('student_id', studentId);

      final isRegistered = existingRegistrations.isNotEmpty;
      _registrationStatus[cacheKey] = isRegistered;
      notifyListeners();
      return isRegistered;
    } catch (error) {
      print('Error checking student registration: $error');
      return false;
    }
  }

  void resetState() {
    _isLoading = false;
    _error = null;
    _isSuccess = false;
    _registrationStatus.clear();
    notifyListeners();
  }
}

