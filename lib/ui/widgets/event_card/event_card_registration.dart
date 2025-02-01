import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/event_registration_provider.dart';


class EventCardRegistration extends StatelessWidget {
  final int registrations;
  final int maxParticipants;
  final int eventId;
  final String? currentStudentId;
  final String status;
  final Function onRegister;

  const EventCardRegistration({
    Key? key,
    required this.registrations,
    required this.maxParticipants,
    required this.eventId,
    required this.currentStudentId,
    required this.status,
    required this.onRegister,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(
          width: double.infinity,
          child: FutureBuilder<bool>(
            future: Provider.of<EventRegistrationProvider>(context, listen: false)
                .isStudentRegistered(eventId: eventId, studentId: currentStudentId ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final isRegistered = snapshot.data ?? false;
                return ElevatedButton(
                  onPressed: (status == 'Active' && !isRegistered && currentStudentId != null)
                      ? () => onRegister()
                      : null,
                  child: Text(isRegistered ? 'Already Registered' : 'Register'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: isRegistered ? Colors.grey : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

