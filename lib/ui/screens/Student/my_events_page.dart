import 'package:flutter/material.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/registered_events_provider.dart';
import '../../widgets/registered_event_card.dart';
import '../../widgets/category_tabs.dart';

//enum EventFilter { all, present, absent }

class MyEventsPage extends StatefulWidget {
  final String studentId;

  const MyEventsPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filterCategories = ['All', 'Present', 'Absent'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegisteredEventsProvider>(context, listen: false)
          .fetchRegisteredEvents(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'My Events',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          FilterTabs(
            categories: _filterCategories,
            selectedIndex: _selectedFilterIndex,
            onCategorySelected: (index) {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
          ),
          Expanded(
            child: Consumer<RegisteredEventsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[200]!),
                    ),
                  );
                }

                final filteredEvents = _filterEvents(provider.registeredEvents);

                if (filteredEvents.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final event = filteredEvents[index];
                    return RegisteredEventCard(
                      event: event,
                      studentId: widget.studentId,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterEvents(List<dynamic> events) {
    switch (_selectedFilterIndex) {
      case 1: // Present
        return events.where((event) => event['filter'] == 'present').toList();
      case 2: // Marked Attendance
        return events.where((event) => event['filter'] == 'absent').toList();
      case 0: // All
      default:
        return events;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 72,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'No Events Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            _getEmptyStateMessage(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Browse Events',
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getEmptyStateMessage() {
    switch (_selectedFilterIndex) {
      case 1: // Present
        return 'You haven\'t attended any events yet.\nCheck back after attending an event!';
      case 2: // Marked Attendance
        return 'No events with marked attendance.\nAttend an event and have your attendance marked!';
      case 0: // All
      default:
        return 'You haven\'t registered for any events yet.\nBrowse and register for events to see them here!';
    }
  }
}

