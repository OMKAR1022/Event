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
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_today_outlined, size: 18, color: Colors.blue),
            ),
            SizedBox(width: 8),
            Text(
              formattedDate,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(width: 16),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.access_time_outlined, size: 18, color: Colors.blue),
            ),
            SizedBox(width: 8),
            Text(
              formattedTime,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_on_outlined, size: 18, color: Colors.blue),
            ),
            SizedBox(width: 8),
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

