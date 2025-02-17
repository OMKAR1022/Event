import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/student/drawer/student_my_events/registered_event_card.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/registered_events_provider.dart';
import '../../../../../widgets/category_tabs.dart';
import '../../widget/student_app_bar.dart';
import '../../widget/student_search_bar.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegisteredEventsProvider>(context, listen: false)
          .fetchRegisteredEvents(widget.studentId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              floating: false,
              backgroundColor: Colors.grey[50],
              elevation: 0,
              title: Text(
                'My Events',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: SearchBar_student(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            SliverToBoxAdapter(
              child: FilterTabs(
                categories: _filterCategories,
                selectedIndex: _selectedFilterIndex,
                onCategorySelected: (index) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                },
              ),
            ),
            Consumer<RegisteredEventsProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[200]!),
                      ),
                    ),
                  );
                }

                final filteredEvents = _filterAndSearchEvents(provider.registeredEvents);

                if (filteredEvents.isEmpty) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final event = filteredEvents[index];
                      return RegisteredEventCard(
                        event: event,
                        studentId: widget.studentId,
                      );
                    },
                    childCount: filteredEvents.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _filterAndSearchEvents(List<dynamic> events) {
    List<dynamic> filteredEvents = events;

    // Apply category filter
    switch (_selectedFilterIndex) {
      case 1: // Present
        filteredEvents = filteredEvents.where((event) => event['filter'] == 'present').toList();
        break;
      case 2: // Marked Attendance
        filteredEvents = filteredEvents.where((event) => event['filter'] == 'absent').toList();
        break;
      case 0: // All
      default:
      // No additional filtering needed
        break;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredEvents = filteredEvents.where((event) =>
      (event['title']?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) ||
          (event['club_name']?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase())
      ).toList();
    }

    return filteredEvents;
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
            onPressed: () => Navigator.of(context).pop(),
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
    if (_searchQuery.isNotEmpty) {
      return 'No events match your search.\nTry a different search term or clear the search.';
    }
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

