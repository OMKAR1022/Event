import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/notification_provider.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _selectedFilter = 'All';

  Widget _buildNotificationIcon(String type) {
    final iconData;
    final backgroundColor;
    final iconColor;

    switch (type) {
      case 'new_event':
        iconData = Icons.event;
        backgroundColor = Colors.blue[50];
        iconColor = Colors.blue[700];
        break;
      case 'registration':
        iconData = Icons.check_circle;
        backgroundColor = Colors.green[50];
        iconColor = Colors.green[700];
        break;
      case 'venue_change':
        iconData = Icons.warning;
        backgroundColor = Colors.amber[50];
        iconColor = Colors.amber[700];
        break;
      case 'reminder':
        iconData = Icons.access_time;
        backgroundColor = Colors.purple[50];
        iconColor = Colors.purple[700];
        break;
      default:
        iconData = Icons.notifications;
        backgroundColor = Colors.grey[50];
        iconColor = Colors.grey[700];
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, color: iconColor, size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All'),
                SizedBox(width: 8),
                _buildFilterChip('Events'),
                SizedBox(width: 8),
                _buildFilterChip('Updates'),
              ],
            ),
          ),
          Expanded(
            child: Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                if (notificationProvider.notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group notifications by date
                final groupedNotifications = _groupNotifications(notificationProvider.notifications);

                return ListView.builder(
                  itemCount: groupedNotifications.length,
                  itemBuilder: (context, index) {
                    final date = groupedNotifications.keys.elementAt(index);
                    final notifications = groupedNotifications[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        ...notifications.map((notification) => _buildNotificationCard(notification)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(EventNotification notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Provider.of<NotificationProvider>(context, listen: false)
              .markAsRead(notification.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(_getNotificationType(notification.title)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNotificationType(String title) {
    if (title.contains('New Event')) return 'new_event';
    if (title.contains('Registration')) return 'registration';
    if (title.contains('Venue')) return 'venue_change';
    if (title.contains('Reminder')) return 'reminder';
    return 'default';
  }

  Map<String, List<EventNotification>> _groupNotifications(List<EventNotification> notifications) {
    final grouped = <String, List<EventNotification>>{};

    for (var notification in notifications) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(Duration(days: 1));
      final notificationDate = DateTime(
        notification.timestamp.year,
        notification.timestamp.month,
        notification.timestamp.day,
      );

      String dateKey;
      if (notificationDate == today) {
        dateKey = 'Today';
      } else if (notificationDate == yesterday) {
        dateKey = 'Yesterday';
      } else {
        dateKey = DateFormat('MMMM d, y').format(notificationDate);
      }

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('h:mm a').format(timestamp);
    }
  }
}

