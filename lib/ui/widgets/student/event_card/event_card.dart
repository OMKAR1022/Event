import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/event_registration_provider.dart';
import '../../../../utils/screen_size.dart';
import '../../animated_status_dot.dart';
import '../../network_aware_image.dart';
import 'event_card_header.dart';
import 'event_card_details.dart';
import 'event_card_registration.dart';
import 'confirmation_dialog.dart';

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
        content: 'Are you sure you want to register for this event?',
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
    if (words.length <= 80) return description;
    return words.take(80).join(' ') + '...';
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';

    try {
      if (date != 'N/A') {
        final eventDate = DateTime.parse(date);
        formattedDate = DateFormat('MMM dd, yyyy').format(eventDate);
        formattedTime = startTime.substring(0, 5);
      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    final status = _getEventStatus();
    final statusColor = _getStatusColor(status);

    return Consumer<EventRegistrationProvider>(
      builder: (context, registrationProvider, child) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(-2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl.isNotEmpty)
                GestureDetector(
                  onTap: onImageTap,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: Hero(
                      tag: 'event_image_$id',
                      child: NetworkAwareImage(
                        imageUrl: imageUrl,
                        width: ScreenSize.width(context),
                        height: ScreenSize.height(context, 4),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        _buildStatusBadge(status),
                      ],
                    ),
                    SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Organized by : ',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: clubName,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _limitDescription(description),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildInfoChip(Icons.calendar_today_outlined, formattedDate),
                        SizedBox(width: 12),
                        _buildInfoChip(Icons.access_time_outlined, formattedTime),
                      ],
                    ),
                    SizedBox(height: 12),
                    _buildInfoChip(Icons.location_on_outlined, venue),
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
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '$maxParticipants Slots',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
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
                                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color:  _getStatusColor(status),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(-2, 2)
            )
          ]
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedStatusDot(
            color: Colors.white,
            isActive: status == 'Active',
          ),
          SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

