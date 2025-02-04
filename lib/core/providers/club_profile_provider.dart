import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubProfileProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  String _clubName = '';
  int _memberCount = 0;
  List<Map<String, dynamic>> _clubMembers = [];
  Map<String, dynamic>? _currentUser;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String get clubName => _clubName;
  int get memberCount => _memberCount;
  List<Map<String, dynamic>> get clubMembers => _clubMembers;
  Map<String, dynamic>? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;

  Future<void> fetchClubProfile(String clubId) async {
    _isLoading = true;
    _errorMessage = null;
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
      _isLoading = false;
      _errorMessage = 'Failed to fetch club profile: $e';
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
      } else {
        throw Exception('Current user is not set');
      }
    } catch (e) {
      _errorMessage = 'Error updating email: $e';
      notifyListeners();
      throw Exception(_errorMessage);
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
      } else {
        throw Exception('Current user is not set');
      }
    } catch (e) {
      _errorMessage = 'Error updating password: $e';
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  Future<void> addMember(String name, String email) async {
    try {
      final newMember = await _supabase
          .from('club_members')
          .insert({
        'name': name,
        'email': email,
        'club_id': _currentUser!['club_id']
      })
          .select()
          .single();

      _clubMembers.add(newMember);
      _memberCount++;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error adding member: $e';
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }

  Future<void> removeMember(String memberId) async {
    try {
      await _supabase
          .from('club_members')
          .delete()
          .eq('id', memberId);

      _clubMembers.removeWhere((member) => member['id'] == memberId);
      _memberCount--;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error removing member: $e';
      notifyListeners();
      throw Exception(_errorMessage);
    }
  }
}