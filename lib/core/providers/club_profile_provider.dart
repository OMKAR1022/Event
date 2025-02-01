import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubProfileProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String _clubName = '';
  int _memberCount = 0;
  List<Map<String, dynamic>> _clubMembers = [];
  Map<String, dynamic>? _currentUser;

  bool get isLoading => _isLoading;
  String get clubName => _clubName;
  int get memberCount => _memberCount;
  List<Map<String, dynamic>> get clubMembers => _clubMembers;
  Map<String, dynamic>? get currentUser => _currentUser;

  Future<void> fetchClubProfile(String clubId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch club information
      final clubResponse = await _supabase
          .from('clubs')
          .select()
          .eq('id', clubId)
          .single();

      _clubName = clubResponse['name'];

      // Fetch club members
      final membersResponse = await _supabase
          .from('club_members')
          .select()
          .eq('club_id', clubId);

      _memberCount = membersResponse.length;
      _clubMembers = List<Map<String, dynamic>>.from(membersResponse);

      // Fetch current user information (assuming it's the first member for now)
      if (_clubMembers.isNotEmpty) {
        _currentUser = _clubMembers[0];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching club profile: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      if (_currentUser != null) {
        await _supabase
            .from('club_members')
            .update({'email': newEmail})
            .eq('id', _currentUser!['id']);

        _currentUser!['email'] = newEmail;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating email: $e');
      rethrow;
    }
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    try {
      if (_currentUser != null) {
        // First, verify the current password
        final response = await _supabase
            .from('club_members')
            .select('password_hash')
            .eq('id', _currentUser!['id'])
            .single();

        if (response['password_hash'] == currentPassword) {
          // If the current password is correct, update to the new password
          await _supabase
              .from('club_members')
              .update({'password_hash': newPassword})
              .eq('id', _currentUser!['id']);

          notifyListeners();
        } else {
          throw Exception('Current password is incorrect');
        }
      }
    } catch (e) {
      print('Error updating password: $e');
      rethrow;
    }
  }
}

