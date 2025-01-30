import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mit_event/ui/widgets/club_event_card.dart';
import '../../../core/providers/event_provider.dart';
import '../../widgets/DashboardCard.dart';

class AdminHome extends StatelessWidget {
  final String clubName;
  final int totalEvents;

  const AdminHome({Key? key, required this.clubName, required this.totalEvents}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access EventProvider to get events
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('$clubName'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://imgs.search.brave.com/zL-v0qYrjFpjvRn0YxWh2XT9kSSBCxR-sQf_bThtMRM/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9uYXRp/b25hbC11LmVkdS5w/aC93cC1jb250ZW50/L3VwbG9hZHMvMjAy/NC8wNy9HRFNDLUxv/Z28uanBn'), // Replace with a valid URL
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardCard(title: 'Total Events', count: totalEvents),
                DashboardCard(title: 'Registrations', count: 156),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Recent Events',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Use ListView.builder to display events
            eventProvider.isLoading
                ? Center(child: CircularProgressIndicator()) // Show a loading indicator while events are being fetched
                : Expanded(
              child: ListView.builder(
                itemCount: eventProvider.events.length,
                itemBuilder: (context, index) {
                  final event = eventProvider.events[index];

                  // Safely handle potential null values
                  final title = event['title'] ?? 'Untitled Event';
                  final date = event['start_time'] ?? 'No Date Available';
                  final registrations = event['registrations'] ?? 0; // Default to 0 if null
                  final status = event['status'] ?? 'Unknown';
                  final statusColor = status == 'Closed'
                      ? Colors.red
                      : status == 'Open'
                      ? Colors.green
                      : Colors.orange;

                  return EventCard(
                    title: title,
                    date: date,
                    registrations: registrations,
                    status: status,
                    statusColor: statusColor,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
