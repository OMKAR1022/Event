import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/admin_hoem.dart';
import 'package:mit_event/ui/screens/Student/student_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider with ChangeNotifier {
  String _userType = 'Student';

  String get userType => _userType;

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
  }

  // Updated Supabase login logic with user type check
  Future<void> login(String username, String password, BuildContext context) async {
    try {
      // Perform the sign-in operation
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: username, // Assuming username is the email
        password: password,
      );

      // Check if session is created successfully
      if (response.session != null) {
        // Check user type before navigating
        if (_userType == 'Student') {
          // Assuming that student email should have 'student' in it for validation
          if (username.contains('student')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StudentHome()),
            );
          } else {
            _showErrorSnackbar(context, 'Invalid student credentials.');
          }
        } else if (_userType == 'Club Member') {
          // Assuming that club member email should have 'club' in it for validation
          if (username.contains('club')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHoem()),
            );
          } else {
            _showErrorSnackbar(context, 'Invalid club member credentials.');
          }
        }
      } else {
        // Show error message if login fails
        _showErrorSnackbar(context, 'Login failed. Please check your credentials.');
      }
    } on AuthException catch (e) {
      // Handle Supabase authentication-specific errors
      _showErrorSnackbar(context, 'Authentication error: ${e.message}');
    } catch (e) {
      // Handle unexpected errors
      _showErrorSnackbar(context, 'An unexpected error occurred: $e');
    }
  }

  // Helper method to show error messages
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
