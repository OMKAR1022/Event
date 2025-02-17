import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/student/widget/student_settings_page.dart';

import '../../Student/widget/student_notification_page.dart';


class StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showNotification;
  final bool showLogo;
  final bool showsetting;

  const StudentAppBar({
    Key? key,
    this.title = '',
    this.showNotification = true,
    this.showLogo = true,
    this.showsetting = false
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: showLogo
            ? CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/event.png'),
          radius: 25,
        )
            : Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: [
          if (showNotification)
            IconButton(
              icon: Icon(Icons.notifications_none_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              },
            ),
          if (showsetting)
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentSettingsPage()),
                );
              },
            ),

        ],
      ),
    );
  }
}

