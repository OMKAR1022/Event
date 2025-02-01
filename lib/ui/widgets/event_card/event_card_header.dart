import 'package:flutter/material.dart';

class EventCardHeader extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String clubName;

  const EventCardHeader({
    Key? key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.clubName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

