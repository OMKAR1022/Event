import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/student/register.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final String venue;
  final String category;
  final int maxParticipants;
  final String registrationDeadline;
  final String imageUrl;
  final int id;
  final int registrations;
  final VoidCallback onImageTap;
  final String clubName;

  const EventCard({
    Key? key,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.venue,
    required this.category,
    required this.maxParticipants,
    required this.registrationDeadline,
    required this.imageUrl,
    required this.id,
    required this.registrations,
    required this.onImageTap,
    required this.clubName,
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
      case 'Full':
        return Colors.orange;
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
        formattedTime = '$startTime - $endTime';
      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    final status = _getEventStatus();
    final statusColor = _getStatusColor(status);

    print('Debug: Event status: $status');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            GestureDetector(
              onTap: onImageTap,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
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
                          color: Colors.blue[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Organized by: $clubName',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      formattedTime,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        venue,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: status == 'Active' ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Register(event_id: id)
                        ),
                      );
                    } : null,
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

