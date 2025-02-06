import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.purple[400],
      ),
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          // Default version info
          String version = 'Version: Loading...';

          if (snapshot.hasData) {
            version = 'Version: ${snapshot.data!.version} (Build ${snapshot.data!.buildNumber})';
          }

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              _buildSection('App Overview',
                  'Our event management app helps clubs and students organize and participate in campus events easily.'),
              _buildSection('Version', version),
              _buildSection('Developers',
                  'Developed by the MIT Event Team'),
              _buildSection('Contact Us',
                  'Email: support@mitevent.com\nWebsite: www.mitevent.com'),
              _buildSection('Privacy Policy',
                  'Tap here to view our privacy policy',
                  onTap: () {
                    _showDialog(context, 'Privacy Policy', 'Our privacy policy details...');
                  }),
              _buildSection('Terms of Service',
                  'Tap here to view our terms of service',
                  onTap: () {
                    _showDialog(context, 'Terms of Service', 'Our terms of service state...');
                  }),
              _buildSection('Acknowledgments',
                  'We use the following open-source libraries:\n- Flutter\n- Supabase'),
              _buildSection('Follow Us',
                  'Find us on:\n- Instagram\n- Twitter\n- Facebook'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content, {VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple[700])),
        subtitle: Text(content, style: TextStyle(color: Colors.black87)),
        onTap: onTap,
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

