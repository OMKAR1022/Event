import 'package:flutter/material.dart';
import 'package:mit_event/core/providers/login_provider.dart';
import 'package:mit_event/ui/screens/Admin/setting/about_page.dart';
import 'package:mit_event/ui/screens/Admin/setting/change_email_screen.dart';
import 'package:mit_event/ui/screens/Admin/setting/change_password_screen.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';


import '../../../../widgets/confirmation_dialog.dart';
import 'help_support_page.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Settings', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildSectionTitle('Account'),
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
                SizedBox(height: 24),
                _buildSectionTitle('Preferences'),
                _buildNotificationToggle(),
                _buildSettingItem(
                  context,
                  icon: Icons.language,
                  title: 'Language',
                  onTap: () {
                    // TODO: Implement language settings
                  },
                ),
                SizedBox(height: 24),
                _buildSectionTitle('Support'),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                  },
                ),
                SizedBox(height: 24),
                _buildLogoutButton(context),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700]),
        title: Text(title,
            style: TextStyle(fontSize: 16, color: Colors.black87)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text('Notifications', style: TextStyle(fontSize: 16, color: Colors.black87)),
        value: _notificationsEnabled,
        onChanged: (bool value) {
          setState(() {
            _notificationsEnabled = value;
          });
          // TODO: Implement notification settings change
        },
        secondary: Icon(Icons.notifications, color: Colors.blue[700]),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => showLogoutConfirmationDialog(context),
      child: Text('Logout', style: TextStyle(fontSize: 16,color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700],
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      color: AppColors.background,
      child: Column(
        children: [
          Text(
            'MIT Event Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
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

