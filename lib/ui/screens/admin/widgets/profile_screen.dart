import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mit_event/ui/screens/Admin/setting/setting_screen.dart';

import 'package:shimmer/shimmer.dart';
import '../../../../core/providers/club_profile_provider.dart';
import '../../../../core/providers/login_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_button.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final clubId = loginProvider.clubId;
      final loggedInUserId = loginProvider.loggedInUserId;
      if (clubId != null && loggedInUserId != null) {
        Provider.of<ClubProfileProvider>(context, listen: false)
            .fetchClubProfile(clubId, loggedInUserId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Consumer<ClubProfileProvider>(
        builder: (context, profileProvider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              final loginProvider = Provider.of<LoginProvider>(context, listen: false);
              final clubId = loginProvider.clubId;
              final loggedInUserId = loginProvider.loggedInUserId;
              if (clubId != null && loggedInUserId != null) {
                await profileProvider.fetchClubProfile(clubId, loggedInUserId);
              }
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(profileProvider),
                  _buildProfileInfo(profileProvider),
                  _buildMembersList(profileProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ClubProfileProvider profileProvider) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[800]!, Colors.blue[400]!],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Club Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, color: Colors.white),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _buildProfileHeader(profileProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ClubProfileProvider profileProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white,
              child: Text(
                profileProvider.currentUser?['name'] != null
                    ? profileProvider.currentUser!['name'][0].toUpperCase()
                    : 'A',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            profileProvider.clubName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            profileProvider.currentUser?['email'] ?? 'xyz@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(ClubProfileProvider profileProvider) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Club Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.people,
                label: 'Members',
                value: profileProvider.clubMembers.length.toString(),
              ),
              _buildStatItem(
                icon: Icons.event,
                label: 'Events',
                value: '0', // Add actual events count
              ),
              _buildStatItem(
                icon: Icons.star,
                label: 'Rating',
                value: '4.5', // Add actual rating
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue[800], size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList(ClubProfileProvider profileProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Club Members',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                CustomButton(
                  title: 'Add Member',
                  onPressed: () {
                    // TODO: Implement add member functionality
                  },
                  icon: Icons.add,
                  color_1: Colors.blue[800]!,
                  color_2: Colors.blue[600]!,
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: profileProvider.clubMembers.length,
            itemBuilder: (context, index) {
              final member = profileProvider.clubMembers[index];
              return _buildMemberTile(member);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMemberTile(Map<String, dynamic> member) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: Text(
            member['name'][0].toUpperCase(),
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          member['name'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          member['email'],
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red[400]),
          onPressed: () {
            // TODO: Implement remove member functionality
          },
        ),
      ),
    );
  }
}