import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/login_provider.dart';
import '../screens/Student/my_events_page.dart';

class StudentDrawer extends StatelessWidget {
  final String? studentName;
  final String? enrollmentNo;
  final String? email;
  final String? phoneNo;

  const StudentDrawer({
    Key? key,
    this.studentName,
    this.enrollmentNo,
    this.email,
    this.phoneNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    // TODO: Navigate to profile page
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.event_outlined,
                  title: 'My Events',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyEventsPage(
                          studentId: Provider.of<LoginProvider>(context, listen: false).studentId ?? '',
                        ),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {
                    // TODO: Navigate to change password page
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    // TODO: Navigate to settings page
                    Navigator.pop(context);
                  },
                ),
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    // TODO: Navigate to help page
                    Navigator.pop(context);
                  },
                ),
                Divider(color: Colors.grey[300]),
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // TODO: Implement logout
                    Navigator.pop(context);
                  },
                  color: Colors.red[400],
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue[400]!,
            Colors.blue[600]!,
          ],
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: Text(
              studentName?.isNotEmpty == true ? studentName![0].toUpperCase() : 'S',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            studentName ?? 'Student',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (enrollmentNo != null) ...[
            SizedBox(height: 4),
            Text(
              enrollmentNo!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 22,
        color: color ?? Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.grey[800],
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      dense: true,
      visualDensity: VisualDensity.compact,
      onTap: onTap,
      horizontalTitleGap: 0,
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            'MIT Event Management',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16), // Safe area padding
        ],
      ),
    );
  }
}

