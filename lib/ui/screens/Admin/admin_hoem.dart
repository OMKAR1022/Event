import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/create_event_steps/create_event.dart';
import 'package:mit_event/ui/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:mit_event/ui/widgets/admin/club_event_card.dart';
import '../../../core/providers/event_provider.dart';
import '../../widgets/admin/DashboardCard.dart';

import '../../widgets/admin/qr_code_model.dart';

import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/category_tabs.dart';

import 'profile_screen.dart';

import 'package:intl/intl.dart';
import 'event_analytics_page.dart';


class AdminHome extends StatefulWidget {
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
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int _currentIndex = 1; // Update 1
  final PageController _pageController = PageController(initialPage: 1); // Update 2
  String _selectedFilter = 'All';
  final List<String> _categories = ['All', 'Active', 'Completed', 'Registration Closed']; // Update 3

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents(widget.clubId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Update 4
    super.dispose();
  }

  void _showQRCodeModal(BuildContext context, String eventId, String eventTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return QRCodeModal(eventId: eventId, eventTitle: eventTitle);
      },
    );
  }

  String _getEventStatus(Map<String, dynamic> event) {
    final now = DateTime.now();
    final eventDate = DateTime.parse(event['date']);
    final registrationDeadline = DateTime.parse(event['registration_deadline']);

    if (now.isAfter(eventDate)) {
      return 'Completed';
    } else if (now.isAfter(registrationDeadline)) {
      return 'Registration Closed';
    } else {
      return 'Active';
    }
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAppBar(context),
        Expanded(
          child: Consumer<EventProvider>(
            builder: (context, eventProvider, child) {
              if (eventProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                onRefresh: () => eventProvider.fetchEvents(widget.clubId),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDashboardCards(eventProvider),
                        SizedBox(height: 10),
                        _buildFilterTabs(), // Update 4
                        SizedBox(height: 10),
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
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Color(0xffE9EBEA),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            _buildMainContent(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar( // Update 3
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
     // color: Color(0xffE9EBEA),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Club Dashboard',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.clubName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
         CustomButton(
             title: 'New Event',
             onPressed: () async {
               await Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => CreateEventScreen(clubId: widget.clubId)
                   )
               );
               Provider.of<EventProvider>(context, listen: false).fetchEvents(widget.clubId);
             },
             icon: Icons.add,
             color_1: Colors.blue[700]!,
             color_2: Colors.blue[300]!)
        ],
      ),
    );
  }

  Widget _buildDashboardCards(EventProvider eventProvider) {
    int fetchedEventsCount = eventProvider.events.length;
    int displayedTotalEvents = fetchedEventsCount > widget.totalEvents ? fetchedEventsCount : widget.totalEvents;
    int totalRegistrations = eventProvider.events.fold(0, (sum, event) => sum + (event['registrations'] as int? ?? 0));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DashboardCard(
            title: 'Total Events',
            count: displayedTotalEvents,
            icon: Icons.event,
            color: Colors.blue[700]!,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DashboardCard(
            title: 'Total Registrations',
            count: totalRegistrations,
            icon: Icons.person,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildEventList(EventProvider eventProvider) {
    if (eventProvider.events.isEmpty) {
      return Center(
        child: Text(
          'No events available.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    final filteredEvents = eventProvider.events.where((event) {
      final status = _getEventStatus(event);
      return _selectedFilter == 'All' || status == _selectedFilter;
    }).toList();

    if (filteredEvents.isEmpty) {
      return Center(
        child: Text(
          'No events match the selected filter.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        final event = filteredEvents[index];
        final status = _getEventStatus(event);
        return EventCard(
          title: event['title'] ?? 'Untitled Event',
          date: event['date'] ?? 'No Date Available',
          startTime: event['start_time']?.substring(0, 5) ?? 'N/A',
          endTime: event['end_time'] ?? 'N/A',
          registrations: event['registrations'] ?? 0,
          maxParticipants: event['max_participants'] ?? 0,
          registrationDeadline: event['registration_deadline'] ?? 'N/A',
          onGenerateQR: (title) => _showQRCodeModal(context, event['id'].toString(), title),
          status: status,
          imageUrl: event['image_url'] ?? '',
          description: event['description'] ?? 'No description available.',
          onAnalytics: status == 'Completed' ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventAnalyticsPage(
                  eventId: event['id'].toString(),
                  eventTitle: event['title'],
                ),
              ),
            );
          } : null, venue: event['venue'],
        );
      },
    );
  }

  Widget _buildFilterTabs() { // Update 2
    return FilterTabs(
      categories: ['All', 'Active', 'Completed', 'Registration Closed'],
      selectedIndex: _categories.indexOf(_selectedFilter),
      onCategorySelected: (index) {
        setState(() => _selectedFilter = _categories[index]);
      },
    );
  }
}

