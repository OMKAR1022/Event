import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/student_event_provider.dart';
import '../../../Student/widget/student_event_card/event_card.dart';

class EventList extends StatelessWidget {
  final String selectedCategory;
  final String searchQuery;
  final String? currentStudentId;
  final Function(String) onImageTap;

  const EventList({
    Key? key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.currentStudentId,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentEventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (eventProvider.events.isEmpty) {
          return Center(child: Text('No events found'));
        } else {
          final filteredEvents = eventProvider.events.where((event) {
            final matchesCategory = selectedCategory == "All Events" ||
                event['category'] == selectedCategory;
            final matchesSearch =
            event['title'].toLowerCase().contains(searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
          }).toList();

          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child:  EventCard(
                  title: event['title'] ?? 'N/A',
                  date: event['date'] ?? 'N/A',
                  startTime: event['start_time']?.substring(0, 5) ?? 'N/A',
                  endTime: event['end_time'] ?? 'N/A',
                  venue: event['venue'] ?? 'N/A',
                  category: event['category'] ?? 'N/A',
                  maxParticipants: event['max_participants'] ?? 0,
                  registrationDeadline: event['registration_deadline'] ?? 'N/A',
                  imageUrl: event['image_url'] ?? '',
                  id: event['id'],
                  registrations: event['registrations'] ?? 0,
                  onImageTap: () => onImageTap(event['image_url'] ?? ''),
                  clubName: event['clubs']['name'] ?? 'N/A',
                  currentStudentId: currentStudentId,
                  description: event['description'] ?? 'No description available.',
                ),
              );
            },
          );
        }
      },
    );
  }
}

