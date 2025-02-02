import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/admin_hoem.dart';
import 'package:mit_event/ui/screens/Student/student_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:provider/provider.dart';


class LoginProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  String? _clubId;
  String? _studentId;
  String? _studentName;
  String? get clubId => _clubId;
  String? get studentId => _studentId;
  String? get studentName => _studentName;

  Future<void> login(String username, String password, BuildContext context) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('club_members')
          .select('email, password_hash, club_id')
          .eq('email', username)
          .maybeSingle();

      if (response != null) {
        if (password == response['password_hash']) {
          _clubId = response['club_id'].toString();
          notifyListeners();

          print('Club ID from database: ${response['club_id']}');
          print('Club ID type: ${response['club_id'].runtimeType}');

          final clubId = response['club_id'].toString();
          print('Using Club ID as String: $clubId');

          print('Converted Club ID: $clubId');

          final clubResponse = await supabase
              .from('clubs')
              .select('name')
              .eq('id', clubId)
              .maybeSingle();

          if (clubResponse != null) {
            final clubName = clubResponse['name'];

            // Fetch total events for this club
            final eventResponse = await supabase
                .from('event')
                .select()
                .eq('club_id', clubId);

            final totalEvents = eventResponse.length;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => //StudentHome()
                AdminHome(
                  clubName: clubName,
                  clubId: clubId,
                  totalEvents: totalEvents,
                ),
              ),
            );
          } else {
            _showErrorSnackbar(context, 'No club found for this user.');
          }
        } else {
          _showErrorSnackbar(context, 'Login failed. Please check your credentials.');
        }
      } else {
        _showErrorSnackbar(context, 'No user found with that email.');
      }
    } catch (e) {
      _showErrorSnackbar(context, 'An unexpected error occurred: $e');
    }
  }

  Future<void> loginStudent(String enrollNo, String password, BuildContext context) async {
    final response = await _supabase
        .from('student_user')
        .select('id, enroll_no, password, name, email, phone_no')
        .eq('enroll_no', enrollNo)
        .maybeSingle();

    if (response != null) {
      if (password == response['password']) {
        _studentId = response['id']?.toString();
        _studentName = response['name'];
        notifyListeners();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHome(
              currentStudentId: _studentId,
              studentName: _studentName,
              enrollmentNo: response['enroll_no'],
              email: response['email'],
              phoneNo: response['phone_no'],
            ),
          ),
        );
      } else {
        _showErrorSnackbar(context, 'Login failed. Please check your credentials.');
      }
    } else {
      _showErrorSnackbar(context, 'No student found with that enrollment number.');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

