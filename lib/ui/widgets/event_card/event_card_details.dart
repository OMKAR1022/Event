import 'package:flutter/material.dart';

class EventCardDetails extends StatelessWidget {
  final String category;
  final String formattedDate;
  final String formattedTime;
  final String venue;

  const EventCardDetails({
    Key? key,
    required this.category,
    required this.formattedDate,
    required this.formattedTime,
    required this.venue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

