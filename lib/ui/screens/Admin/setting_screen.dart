import 'package:flutter/material.dart';
import 'package:mit_event/core/providers/login_provider.dart';
import 'package:mit_event/ui/screens/Admin/about_page.dart';
import 'package:mit_event/ui/screens/Admin/change_email_screen.dart';
import 'package:mit_event/ui/screens/Admin/change_password_screen.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../widgets/confirmation_dialog.dart';
import 'help_support_page.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Settings'),
        backgroundColor: AppColors.background,
      ),
      body: Column( // Use Column to align items vertically
        children: [
          Expanded( // Expand the ListView to fill available space
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.email,
                    title: 'Change Email',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangeEmailScreen()),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.lock,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.notifications,
                    title: 'Notification Settings',
                    onTap: () {
                      // TODO: Implement notification settings
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {
                      // TODO: Implement language settings
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HelpSupportPage()),
                      );
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) =>AboutPage()));
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () => showLogoutConfirmationDialog(context),
                    isLogout: true, // Add this flag
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(), // Footer at the bottom
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap,
        bool isLogout = false}) {
    return Card(
      color: isLogout ? Colors.redAccent : AppColors.card,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.white : Colors.blue),
        title: Text(title,
            style: TextStyle(
                fontSize: 16, color: isLogout ? Colors.white : Colors.black87)),
        trailing: Icon(Icons.arrow_forward_ios,
            color: isLogout ? Colors.white : Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16), // Reduced padding
      color: AppColors.background, // Background color for the footer
      child: Column(
        children: [

          SizedBox(height: 8),
          Text(
            'MIT Event Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700], // Changed color to grey
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500], // Changed color to grey
            ),
          ),
        ],
      ),
    );
  }
  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Logout',
          content: 'Are you sure you want to logout?',
          confirmText: 'Logout',
          cancelText: 'Cancel',
          onConfirm: () {
            Provider.of<LoginProvider>(context, listen: false).logout(context);
          },
        );
      },
    );
  }
}

