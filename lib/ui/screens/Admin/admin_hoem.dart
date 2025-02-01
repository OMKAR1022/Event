import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/create_event.dart';
import 'package:provider/provider.dart';
import 'package:mit_event/ui/widgets/club_event_card.dart';
import '../../../core/providers/event_provider.dart';
import '../../widgets/DashboardCard.dart';


class AdminHome extends StatelessWidget {
  final String clubName;
  final String clubId;
  final int totalEvents;

  const AdminHome({
    Key? key,
    required this.clubName,
    required this.clubId,
    required this.totalEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    // Add this line to fetch events when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventProvider.fetchEvents(clubId);
    });

    return Scaffold(
      backgroundColor: Color(0xffE9EBEA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDashboardCards(eventProvider),
                      SizedBox(height: 24),
                      Text(
                        'Recent Events',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildEventList(eventProvider),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateEventScreen(clubId: clubId)
              )
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Color(0xffE9EBEA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                clubName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Screenshot%202025-01-31%20at%204.58.16%E2%80%AFPM-1Cjnvj699EIFjWf2v8Soiow5UoRkLw.png'),
            radius: 24,
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCards(EventProvider eventProvider) {
    int fetchedEventsCount = eventProvider.events.length;
    int displayedTotalEvents = fetchedEventsCount > totalEvents ? fetchedEventsCount : totalEvents;
    int totalRegistrations = eventProvider.events.fold(0, (sum, event) => sum + (event['registrations'] as int));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DashboardCard(
            title: 'Total Events',
            count: displayedTotalEvents,
            icon: Icons.event,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DashboardCard(
            title: 'Total Registrations',
            count: totalRegistrations,
            icon: Icons.person,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(EventProvider eventProvider) {
    if (eventProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (eventProvider.events.isEmpty) {
      return Center(
        child: Text(
          'No events available.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: eventProvider.events.length,
      itemBuilder: (context, index) {
        final event = eventProvider.events[index];
        return EventCard(
          title: event['title'] ?? 'Untitled Event',
          date: event['date'] ?? 'No Date Available',
          startTime: event['start_time'] ?? 'N/A',
          endTime: event['end_time'] ?? 'N/A',
          registrations: event['registrations'] ?? 0,
          maxParticipants: event['max_participants'] ?? 0,
          registrationDeadline: event['registration_deadline'] ?? 'N/A',
        );
      },
    );
  }
}

