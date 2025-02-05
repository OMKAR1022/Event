// event_info_card.dart
import 'package:flutter/material.dart';

class EventInfoCard extends StatelessWidget {
  final String formattedDate;
  final String formattedStartTime;
  final String formattedEndTime;
  final String venue;

  const EventInfoCard({
    Key? key,
    required this.formattedDate,
    required this.formattedStartTime,
    required this.formattedEndTime,
    required this.venue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Date Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                formattedDate,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'Date',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(width: 8),
          VerticalDivider(color: Colors.grey),
          SizedBox(width: 8),
          // Time Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '$formattedStartTime ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '- $formattedEndTime',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Time',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(width: 8),
          VerticalDivider(color: Colors.grey),
          SizedBox(width: 8),
          // Venue Column
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                venue,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 4),
              Text(
                'Venue',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
