import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/event_registration_provider.dart';

import 'event_card_header.dart';
import 'event_card_details.dart';
import 'event_card_registration.dart';
import 'confirmation_dialog.dart';

class EventCard extends StatefulWidget {
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
  }) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool _isRegistering = false;

  String _getEventStatus() {
    try {
      final now = DateTime.now();
      final eventDate = DateTime.parse(widget.date);
      final deadline = DateTime.parse(widget.registrationDeadline);

      final startTimeParts = widget.startTime.split(':');
      final endTimeParts = widget.endTime.split(':');
      final eventStartTime = DateTime(
          eventDate.year, eventDate.month, eventDate.day,
          int.parse(startTimeParts[0]), int.parse(startTimeParts[1])
      );
      var eventEndTime = DateTime(
          eventDate.year, eventDate.month, eventDate.day,
          int.parse(endTimeParts[0]), int.parse(endTimeParts[1])
      );

      if (eventEndTime.isBefore(eventStartTime)) {
        eventEndTime = eventEndTime.add(Duration(days: 1));
      }

      if (now.isAfter(eventEndTime)) {
        return 'Completed';
      } else if (now.isBefore(deadline)) {
        if (widget.registrations >= widget.maxParticipants) {
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

  Future<void> _registerForEvent(BuildContext context) async {
    if (_isRegistering) return;

    bool confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Confirm Registration',
          content: 'Are you sure you want to register for this event?',
          cancelText: 'Cancel',
          confirmText: 'Yes, Register',
        );
      },
    ) ?? false;

    if (!confirmed) return;

    setState(() {
      _isRegistering = true;
    });

    final eventRegistrationProvider = Provider.of<EventRegistrationProvider>(context, listen: false);

    try {
      await eventRegistrationProvider.registerForEvent(
        eventId: widget.id,
        studentId: widget.currentStudentId!,
      );

      if (eventRegistrationProvider.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );
      } else if (eventRegistrationProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${eventRegistrationProvider.error}')),
        );
      }
    } finally {
      setState(() {
        _isRegistering = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'N/A';
    String formattedTime = 'N/A';

    try {
      if (widget.date != 'N/A') {
        final eventDate = DateTime.parse(widget.date);
        formattedDate = DateFormat('MMM dd, yyyy').format(eventDate);
        formattedTime = '${widget.startTime} - ${widget.endTime}';
      }
    } catch (e) {
      print('Error formatting date: $e');
    }

    final status = _getEventStatus();
    final statusColor = _getStatusColor(status);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.imageUrl.isNotEmpty)
            GestureDetector(
              onTap: widget.onImageTap,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                child: Image.network(
                  widget.imageUrl,
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
                EventCardHeader(
                  title: widget.title,
                  status: status,
                  statusColor: statusColor,
                  clubName: widget.clubName,
                ),
                SizedBox(height: 16),
                EventCardDetails(
                  category: widget.category,
                  formattedDate: formattedDate,
                  formattedTime: formattedTime,
                  venue: widget.venue,
                ),
                SizedBox(height: 16),
                EventCardRegistration(
                  registrations: widget.registrations,
                  maxParticipants: widget.maxParticipants,
                  eventId: widget.id,
                  currentStudentId: widget.currentStudentId,
                  status: status,
                  onRegister: () => _registerForEvent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

