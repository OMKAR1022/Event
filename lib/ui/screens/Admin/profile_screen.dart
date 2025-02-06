import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mit_event/ui/screens/Admin/setting_screen.dart';
import 'package:mit_event/ui/widgets/custom_button.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/providers/club_profile_provider.dart';
import '../../../core/providers/login_provider.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/wave_clipper.dart';

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
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final clubId = loginProvider.clubId;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.background,
        title: Text('Club Profile'),
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
      ),
      body: Consumer<ClubProfileProvider>(
        builder: (context, profileProvider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              final loggedInUserId = loginProvider.loggedInUserId;
              if (clubId != null && loggedInUserId != null) {
                await profileProvider.fetchClubProfile(clubId, loggedInUserId);
              }
            },
            child: _buildProfileContent(profileProvider, context),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(ClubProfileProvider profileProvider, BuildContext context) {
    final isLoading = profileProvider.isLoading;

    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Header Section with Shimmer Effect
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[900]!, Colors.blue[200]!],
                    ),
                  ),
                  child: Center(
                    child: isLoading
                        ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 40,
                        width: 200,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      profileProvider.clubName,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            blurRadius: 2,
                            offset: Offset(-3, 3),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                child: isLoading
                    ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                  ),
                )
                    : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.lightBlue[100],
                  child: Text(
                    profileProvider.currentUser?['name'] != null
                        ? profileProvider.currentUser!['name'][0].toUpperCase()
                        : 'A',
                    style: TextStyle(fontSize: 40, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),

          // Profile Info Section with Shimmer
          isLoading
              ? _buildShimmerProfile()
              : Column(
            children: [
              Text(
                profileProvider.currentUser?['name'] ?? 'User',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                profileProvider.currentUser?['email'] ?? 'xyz@gmail.com',
                style: TextStyle(fontSize: 18, color: Colors.grey[500]),
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Club Members',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        CustomButton(
                          title: 'Add Member',
                          onPressed: () {
                            // TODO: Implement add member functionality
                          },
                          icon: Icons.add,
                          color_1: Colors.blue[900]!,
                          color_2: Colors.blue[300]!,
                        )
                      ],
                    ),
                    SizedBox(height: 20),

                    // Club Members List
                    ...profileProvider.clubMembers.map((member) {
                      return Card(
                        margin: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                        color: AppColors.card,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.lightBlue[100],
                            child: Text(
                              member['name'][0].toUpperCase(),
                              style: TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(member['name']),
                              Text(member['email'], style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              // TODO: Implement remove member functionality
                            },
                            icon: Icon(Icons.delete, color: Colors.red[700]),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Shimmer Placeholder for Profile Info
  Widget _buildShimmerProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20,
              margin: EdgeInsets.symmetric(vertical: 8),
              width: index == 0 ? 150 : double.infinity,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }
}
