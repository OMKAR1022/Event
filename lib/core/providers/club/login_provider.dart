import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/admin_hoem.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../event_provider.dart';


class LoginProvider with ChangeNotifier {
  Future<void> login(String username, String password, BuildContext context) async {
    try {
      final supabase = Supabase.instance.client;

      // Step 1: Authenticate user by email and password hash
      final response = await supabase
          .from('club_members')
          .select('email, password_hash, club_id')
          .eq('email', username)
          .maybeSingle();

      if (response != null) {
        // Step 2: Check password match (ensure password is hashed before comparing)
        if (password == response['password_hash']) {
          // Debug: Print the club_id value and its type
          print('Club ID from database: ${response['club_id']}');
          print('Club ID type: ${response['club_id'].runtimeType}');

          // Convert club_id to int
          final clubId = response['club_id'].toString(); // Keep it as a string
          print('Using Club ID as String: $clubId');


          // Debug: Print the converted clubId
          print('Converted Club ID: $clubId');

          // Step 3: Fetch the club name
          final clubResponse = await supabase
              .from('clubs')
              .select('name')
              .eq('id', clubId)
              .maybeSingle();

          if (clubResponse != null) {
            final clubName = clubResponse['name'];

            // Step 4: Fetch total events for this club
            final eventProvider = Provider.of<EventProvider>(context, listen: false);
            await eventProvider.fetchEvents(clubId); // Fetch events

            final totalEvents = eventProvider.totalEvents; // Get total event count

            // Step 5: Navigate to AdminHome and pass clubName & totalEvents
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminHome(clubName: clubName, totalEvents: totalEvents),
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

  // Helper method to show error messages
  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}