import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/admin_hoem.dart';
import 'package:mit_event/ui/screens/Student/student_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:provider/provider.dart';


class LoginProvider with ChangeNotifier {
  String? _clubId;
  String? get clubId => _clubId;

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

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

