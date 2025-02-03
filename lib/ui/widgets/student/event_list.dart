import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/student_event_provider.dart';
import '../skeleton_card.dart';
import 'event_card/event_card.dart';


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
          return SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) => SkeletonCard(),
                childCount: 3,
              ),
            ),
          );
        }

        final filteredEvents = _filterEvents(eventProvider.events, selectedCategory, searchQuery);

        if (filteredEvents.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                'No events found.\nTry a different search or category.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final event = filteredEvents[index];
                return EventCard(
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
                );
              },
              childCount: filteredEvents.length,
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _filterEvents(List<Map<String, dynamic>> events, String category, String query) {
    return events.where((event) {
      final matchesSearch = event['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
          event['clubs']['name'].toString().toLowerCase().contains(query.toLowerCase());
      final matchesCategory = category == "All" || event['category'] == category;
      return matchesSearch && matchesCategory;
    }).toList();
  }
}

