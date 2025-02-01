import 'package:flutter/material.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
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
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // TODO: Implement help & support
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // TODO: Implement about page
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.exit_to_app,
            title: 'Logout',
            onTap: () {
              // TODO: Implement logout functionality
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

