import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final int registrations;
  final int maxParticipants;
  final String registrationDeadline;
  final Function(String) onGenerateQR;

  const EventCard({
    Key? key,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.registrations,
    required this.maxParticipants,
    required this.registrationDeadline,
    required this.onGenerateQR,
  }) : super(key: key);

  String _getEventStatus() {
    try {
      final now = DateTime.now();
      final eventDate = DateTime.parse(date);
      final deadline = DateTime.parse(registrationDeadline);

      // Parse start and end times
      final startTimeParts = startTime.split(':');
      final endTimeParts = endTime.split(':');
      final eventStartTime = DateTime(
          eventDate.year, eventDate.month, eventDate.day,
          int.parse(startTimeParts[0]), int.parse(startTimeParts[1])
      );
      var eventEndTime = DateTime(
          eventDate.year, eventDate.month, eventDate.day,
          int.parse(endTimeParts[0]), int.parse(endTimeParts[1])
      );

      // If end time is before start time, assume it's the next day
      if (eventEndTime.isBefore(eventStartTime)) {
        eventEndTime = eventEndTime.add(Duration(days: 1));
      }

      print('Debug: Current date: $now');
      print('Debug: Event date: $eventDate');
      print('Debug: Event start time: $eventStartTime');
      print('Debug: Event end time: $eventEndTime');
      print('Debug: Registration deadline: $deadline');

      if (now.isAfter(eventEndTime)) {
        return 'Completed';
      } else if (now.isBefore(deadline)) {
        if (registrations >= maxParticipants) {
          return 'Full';
        }
        return 'Active';
      } else {
        return 'Registration Closed';
      }
    } catch (e) {
      print('Error determining event status: $e');
      return 'Unknown';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Registration Closed':
        return Colors.orange;
      case 'Completed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';

    try {
      if (date != 'N/A') {
        final eventDate = DateTime.parse(date);
        formattedDate = DateFormat('MMM dd, yyyy').format(eventDate);
        formattedTime = startTime;
      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    final status = _getEventStatus();
    final statusColor = _getStatusColor(status);

    print('Debug: Final status: $status');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert, color: Colors.grey),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Delete'),
                          value: 'delete',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              '$formattedDate • $formattedTime',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$registrations Registered',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$maxParticipants',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: registrations / maxParticipants,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 6,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => onGenerateQR(title),
                    icon: Icon(Icons.qr_code),
                    label: Text('Generate QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

