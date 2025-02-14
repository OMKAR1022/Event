import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mit_event/ui/widgets/student/image_preview.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../core/providers/event_registration_provider.dart';
import '../../../../utils/screen_size.dart';
import '../../animated_status_dot.dart';
import '../../confirmation_dialog.dart';
import '../../event_details_page.dart';
import '../../network_aware_image.dart';
import '../../../../core/models/event_model.dart';

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
  final String? currentStudentId;
  final String description;

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
    required this.currentStudentId,
    required this.description,
  }) : super(key: key);



  String _getEventStatus() {
    try {
      final now = DateTime.now();
      final eventDate = DateTime.parse(date);
      final deadline = DateTime.parse(registrationDeadline);

      final startTimeParts = startTime.split(':');
      final endTimeParts = endTime.split(':');
      final eventStartTime = DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
        int.parse(startTimeParts[0]),
        int.parse(startTimeParts[1]),
      );
      var eventEndTime = DateTime(
        eventDate.year,
        eventDate.month,
        eventDate.day,
        int.parse(endTimeParts[0]),
        int.parse(endTimeParts[1]),
      );

      if (eventEndTime.isBefore(eventStartTime)) {
        eventEndTime = eventEndTime.add(Duration(days: 1));
      }

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
        return Colors.teal;
      case 'Full':
        return Colors.orange[700]!;
      case 'Registration Closed':
        return Colors.orange[400]!;
      case 'Completed':
        return Colors.red[700]!;
      default:
        return Colors.grey;
    }
  }

  Future<void> _handleRegistration(BuildContext context, EventRegistrationProvider provider) async {
    if (currentStudentId == null || currentStudentId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Student ID not found. Please log in again.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: 'Confirm Registration',
        content: 'Are you sure you want to register for this event?', onConfirm: () {  },
      ),
    );

    if (confirmed == true) {
      try {
        await provider.registerForEvent(
          eventId: id,
          studentId: currentStudentId!,
        );

        if (provider.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully registered for the event!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (provider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(provider.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _limitDescription(String description) {
    List<String> words = description.split(' ');
    if (words.length <= 100) return description;
    return words.take(100).join(' ') + '...';
  }


  @override
  Widget build(BuildContext context) {


    String formattedDate = 'N/A';
    String formattedTime = 'N/A';

    try {
      if (date != 'N/A') {
        final eventDate = DateTime.parse(date);
        formattedDate = DateFormat('MMM dd, yyyy').format(eventDate);
        formattedTime = '${startTime.substring(0, 5)} - ${endTime.substring(0, 5)}';
      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    final status = _getEventStatus();
    final statusColor = _getStatusColor(status);


    return Consumer<EventRegistrationProvider>(
      builder: (context, registrationProvider, child) {
        return GestureDetector(
          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsPage(imageUrl: imageUrl, description: description, title: title,),

              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  child: Stack(
                    children: [
                      NetworkAwareImage(
                        imageUrl: imageUrl,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                                Colors.black.withOpacity(0.4),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(),
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                category,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedStatusDot(
                                color: _getStatusColor(status),
                                isActive: status == 'Active',
                              ),
                              SizedBox(width: 8),
                              Text(
                                status,
                                style: GoogleFonts.poppins(
                                  color: _getStatusColor(status),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.9),
                          height: 1.2,
                        ),
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
                            child: Icon(
                              Icons.groups_rounded,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Organized by ',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            clubName,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (description.isNotEmpty) ...[
                        Text(maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          _limitDescription(description),
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.5

                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow(
                              Icons.calendar_today_rounded,
                              'Date',
                              formattedDate,
                            ),
                            SizedBox(height: 12),
                            _buildDetailRow(
                              Icons.access_time_rounded,
                              'Time',
                              formattedTime,
                            ),
                            SizedBox(height: 12),
                            _buildDetailRow(
                              Icons.location_on_rounded,
                              'Venue',
                              venue,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Registration Progress',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Text(
                                '$registrations/$maxParticipants',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: registrations / maxParticipants,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue[400]!,
                                        Colors.blue[600]!,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      FutureBuilder<bool>(
                        future: registrationProvider.isStudentRegistered(
                          eventId: id,
                          studentId: currentStudentId ?? '',
                        ),
                        builder: (context, snapshot) {
                          final isRegistered = snapshot.data ?? false;
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (status == 'Active' && !isRegistered)
                                  ? () => _handleRegistration(context, registrationProvider)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isRegistered ? Colors.grey[300] : Colors.blue[900],
                                padding: EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: status == 'Active' && !isRegistered ? 2 : 0,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                isRegistered
                                    ? 'Already Registered'
                                    : status == 'Active'
                                    ? 'Register Now'
                                    : 'Registration Closed',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'academic':
        return Icons.school_rounded;
      case 'cultural':
        return Icons.palette_rounded;
      case 'sports':
        return Icons.sports_rounded;
      case 'workshop':
        return Icons.build_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.blue[700],
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

