import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/event_provider.dart';
import '../../widgets/event_card.dart'; // Import the EventCard widget

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  @override
  void initState() {
    super.initState();
    // Fetch events when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const TextField(
          decoration: InputDecoration(
            hintText: "Search events...",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey,
          ),
        ),
      ),
      body: eventProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
          ? const Center(
        child: Text('No events available.'),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            title: event['title'] ?? 'N/A',
            department: event['department'] ?? 'N/A',
            date: event['date'] ?? 'N/A',
            start_time: event['start_time'] ?? 'N/A',
            status: event['status'] ?? 'N/A',
            imageUrl: event['imageUrl'] ?? '',
          );
        },
      ),
    );
  }
}
