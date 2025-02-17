import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/event_details_page.dart';
import '../../../../widgets/event_info.dart';


class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final int registrations;
  final int maxParticipants;
  final String registrationDeadline;
  final Function(String) onGenerateQR;
  final String status;
  final VoidCallback? onAnalytics;
  final String venue;
  final String description;
  final String imageUrl;
  final String clubname;

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
    required this.status,
    required this.venue,
    required this.imageUrl,
    required this.description,
    required this.clubname,
    this.onAnalytics,
  }) : super(key: key);


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
    String formattedStartTime = 'N/A';
    String formattedEndTime ='N/A';

    try {
      if (date != 'N/A') {
        final eventDate = DateTime.parse(date);
        formattedDate = DateFormat('MMM dd, yyyy').format(eventDate);
        formattedStartTime = startTime;
        formattedEndTime = endTime.substring(0,5);

      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    final statusColor = _getStatusColor(status);

    print('Debug: Final status: $status');

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder : (context) =>EventDetailsPage(imageUrl: imageUrl, description: description, title: title, registrations: registrations, club_name: clubname,)));
      },
      child: Card(
       // elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              gradient: LinearGradient(colors: [Colors.blue[50]!,Colors.white],begin:Alignment.center,end: Alignment.bottomLeft),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(2, 4),
              )
            ]
          ),
          child: Stack(
            children: [
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                left: -30,
                bottom: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.1),
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
                   EventInfoCard(
                       formattedDate: formattedDate,
                       formattedStartTime: formattedStartTime,
                       formattedEndTime: formattedEndTime,
                       venue: venue),
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
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                  title: 'Generate QR',
                                onPressed: () => onGenerateQR(title),
                                icon: Icons.qr_code, color_1: Colors.blue,color_2: Colors.purple,
                                //backgroundColor: Colors.blue[700]!,
                              )
                            ),
                            if (status == 'Completed' && onAnalytics != null) ...[
                              SizedBox(width: 8),
                              Expanded(
                                child:CustomButton(
                                  title: 'Analytics',
                                  onPressed: onAnalytics!,
                                  icon: Icons.analytics,color_1: Colors.teal[700]!,color_2: Colors.teal[200]!,
                                )
                              ),
                            ],
                          ],
                        ),
                      ],
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
}

