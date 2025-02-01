import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/setting_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/club_profile_provider.dart';

import '../../../core/providers/login_provider.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clubId = Provider.of<LoginProvider>(context, listen: false).clubId;
      if (clubId != null) {
        Provider.of<ClubProfileProvider>(context, listen: false).fetchClubProfile(clubId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ClubProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (profileProvider.currentUser == null) {
            return Center(child: Text('Failed to load user profile'));
          }
          return CustomScrollView(
            slivers: [
              _buildAppBar(profileProvider),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfo(profileProvider),
                      SizedBox(height: 24),
                      _buildClubInfo(profileProvider),
                      SizedBox(height: 24),
                      _buildMembersList(profileProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(ClubProfileProvider profileProvider) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(profileProvider.clubName),
        background: Image.network(
          'https://picsum.photos/800/600', // Replace with your club's image
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildUserInfo(ClubProfileProvider profileProvider) {
    final currentUser = profileProvider.currentUser;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'), // Replace with user's avatar
                radius: 30,
              ),
              title: Text(currentUser?['name'] ?? 'N/A', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              subtitle: Text(currentUser?['email'] ?? 'N/A', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubInfo(ClubProfileProvider profileProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Club Information',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.group, size: 40, color: Colors.blue),
              title: Text('Total Members', style: TextStyle(fontSize: 18)),
              trailing: Text(
                '${profileProvider.memberCount}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersList(ClubProfileProvider profileProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Club Members',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: profileProvider.clubMembers.length,
              itemBuilder: (context, index) {
                final member = profileProvider.clubMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (member['name'] as String?)?.isNotEmpty == true
                          ? (member['name'] as String).substring(0, 1).toUpperCase()
                          : 'N/A',
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(member['name'] ?? 'N/A'),
                  subtitle: Text(member['email'] ?? 'N/A'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

