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
        crossAxisAlignment: CrossAxisAlignment.start, // Fixes alignment issues
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

          VerticalDivider(color: Colors.grey),

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

          VerticalDivider(color: Colors.grey),
          // Venue Column
          Flexible(  // This allows the venue to adjust its width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Align text properly
              children: [
                Text(
                  venue,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis, // Allow text to wrap
                  softWrap: true,                   // Enable wrapping
                  maxLines: 2,                      // Limit to 2 lines
                ),
                SizedBox(height: 4),
                Text(
                  'Venue',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
