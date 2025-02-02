import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentAuthProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;

  Future<void> createAccount({
    required String name,
    required String phoneNo,
    required String email,
    required String enrollNo,
    required String department,
    required String className,
    required String password,
  }) async {
    try {
      // Check if the enrollment number already exists
      final existingUser = await _supabase
          .from('student_user')
          .select()
          .eq('enroll_no', enrollNo)
          .maybeSingle();

      if (existingUser != null) {
        throw Exception('An account with this enrollment number already exists.');
      }

      // If the enrollment number doesn't exist, proceed with account creation
      final response = await _supabase.from('student_user').insert({
        'name': name,
        'phone_no': phoneNo,
        'email': email,
        'enroll_no': enrollNo,
        'department': department,
        'class': className,
        'password': password, // Note: In a real app, you should hash this password
      }).select();

      if (response == null) {
        throw Exception('Failed to create account');
      }

      // You might want to automatically log in the user here
      // or perform any other post-registration actions

      notifyListeners();
    } catch (e) {
      // Re-throw the exception to be handled in the UI
      throw e;
    }
  }
}

