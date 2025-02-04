import 'package:flutter/material.dart';
import 'package:mit_event/utils/screen_size.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/notification_provider.dart';

import '../../screens/Student/notification_page.dart';
import '../gradient_icon_button.dart';

class StudentAppBar extends StatelessWidget {
  final String studentName;
  final VoidCallback onMenuPressed;

  const StudentAppBar({
    Key? key,
    required this.studentName,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Builder( // Add the Builder widget here
                builder: (BuildContext context) { // This context has the Scaffold ancestor
                  return GradientIconButton(
                    icon: Icons.menu,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                }
            ),
            SizedBox(width: ScreenSize.width(context,18)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello 👋,',
                  style: TextStyle(
                    shadows: [
                      Shadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          offset: Offset(-2, 2)
                      )
                    ],
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    studentName,
                    style: TextStyle(
                      shadows: [
                        Shadow(
                            color: Colors.black38,
                            blurRadius: 10,
                            offset: Offset(-2, 1)
                        )
                      ],
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        _buildNotificationButton(context),
      ],
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return GradientIconButton(
      icon: Icons.notifications_outlined,
      onPressed: () {
        final notificationProvider = Provider.of<NotificationProvider>(
            context,
            listen: false
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotificationPage()),
        ).then((_) => notificationProvider.markAllAsRead());
      },
      badge: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (!provider.hasUnreadNotifications) return SizedBox.shrink();
          return Positioned(
            right: 8,
            top: 8,
            child: Container(
              width: ScreenSize.width(context,12),
              height: ScreenSize.height(context,12),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          );
        },
      ),
    );
  }
}

