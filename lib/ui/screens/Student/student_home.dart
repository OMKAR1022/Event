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
      Provider.of<EventProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return DefaultTabController(
      initialIndex: 2,
      length: 4,
      child: Scaffold(
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
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.science),
                text: "Science",
              ),
              Tab(
                icon: Icon(Icons.sports),
                text: "Sports",
              ),
              Tab(
                icon: Icon(Icons.laptop),
                text: "Technical",
              ),
              Tab(
                icon: Icon(Icons.image),
                text: "Design",
              ),
            ],
          ),
        ),
        body: eventProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildEventList(events, "Science"),
            _buildEventList(events, "Sports"),
            _buildEventList(events, "Technical"),
            _buildEventList(events, "Design"),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<Map<String, dynamic>> events, String department) {
    final filteredEvents = events.where((event) => event['department'] == department).toList();

    if (filteredEvents.isEmpty) {
      return const Center(
        child: Text('No events available.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        return EventCard(
          key: ValueKey(event['title']),
          title: event['title'] ?? 'N/A',
          department: event['department'] ?? 'N/A',
          date: event['date'] ?? 'N/A',
          start_time: event['start_time'] ?? 'N/A',
          status: event['status'] ?? 'N/A',
          imageUrl: event['imageUrl'] ?? '',
        );
      },
    );
  }
}
