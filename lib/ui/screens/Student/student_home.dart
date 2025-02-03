import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/student_event_provider.dart';

import '../../widgets/event_card/event_card.dart';
import 'notification_page.dart';
import '../../../core/providers/notification_provider.dart';
import '../../widgets/student_drawer.dart';

class StudentHome extends StatefulWidget {
  final String? currentStudentId;
  final String? studentName;
  final String? enrollmentNo;
  final String? email;
  final String? phoneNo;

  const StudentHome({
    Key? key,
    required this.currentStudentId,
    required this.studentName,
    this.enrollmentNo,
    this.email,
    this.phoneNo,
  }) : super(key: key);

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  String? _previewImageUrl;
  final List<String> _categories = ["All", "Academic", "Cultural", "Sports", "Technical", "Workshop", "Other"];
  int _selectedIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showImagePreview(String imageUrl) {
    setState(() {
      _previewImageUrl = imageUrl;
    });
  }

  void _hideImagePreview() {
    setState(() {
      _previewImageUrl = null;
    });
  }

  List<Map<String, dynamic>> _filterEvents(List<Map<String, dynamic>> events, String category) {
    return events.where((event) {
      final matchesSearch = event['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event['clubs']['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = category == "All" || event['category'] == category;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: StudentDrawer(
        studentName: widget.studentName,
        enrollmentNo: widget.enrollmentNo,
        email: widget.email,
        phoneNo: widget.phoneNo,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildAppBar(),
                    _buildCategoryTabs(),
                  ],
                ),
              ),
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: Provider.of<StudentEventProvider>(context, listen: false).eventsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  }
                  final events = snapshot.data ?? [];
                  final filteredEvents = _filterEvents(events, _categories[_selectedIndex]);
                  return SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final event = filteredEvents[index];
                          return EventCard(
                            title: event['title'] ?? 'N/A',
                            date: event['date'] ?? 'N/A',
                            startTime: event['start_time'] ?? 'N/A',
                            endTime: event['end_time'] ?? 'N/A',
                            venue: event['venue'] ?? 'N/A',
                            category: event['category'] ?? 'N/A',
                            maxParticipants: event['max_participants'] ?? 0,
                            registrationDeadline: event['registration_deadline'] ?? 'N/A',
                            imageUrl: event['image_url'] ?? '',
                            id: event['id'],
                            registrations: event['registrations'] ?? 0,
                            onImageTap: () => _showImagePreview(event['image_url'] ?? ''),
                            clubName: event['clubs']['name'] ?? 'N/A',
                            currentStudentId: widget.currentStudentId,
                          );
                        },
                        childCount: filteredEvents.length,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu, color: Colors.blue[800]),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hello, ${widget.studentName ?? 'Student'}!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.blue[800]),
                    onPressed: () {
                      final notificationProvider = Provider.of<NotificationProvider>(
                          context,
                          listen: false
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NotificationPage()),
                      ).then((_) {
                        notificationProvider.markAllAsRead();
                      });
                    },
                  ),
                  Consumer<NotificationProvider>(
                    builder: (context, provider, child) {
                      if (!provider.hasUnreadNotifications) return SizedBox.shrink();
                      return Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search events by title or club...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
              )
                  : null,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _selectedIndex == index ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: _selectedIndex == index ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventList(List<Map<String, dynamic>> events) {
    if (events.isEmpty) {
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

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final event = events[index];
          return EventCard(
            title: event['title'] ?? 'N/A',
            date: event['date'] ?? 'N/A',
            startTime: event['start_time'] ?? 'N/A',
            endTime: event['end_time'] ?? 'N/A',
            venue: event['venue'] ?? 'N/A',
            category: event['category'] ?? 'N/A',
            maxParticipants: event['max_participants'] ?? 0,
            registrationDeadline: event['registration_deadline'] ?? 'N/A',
            imageUrl: event['image_url'] ?? '',
            id: event['id'],
            registrations: event['registrations'] ?? 0,
            onImageTap: () => _showImagePreview(event['image_url'] ?? ''),
            clubName: event['clubs']['name'] ?? 'N/A',
            currentStudentId: widget.currentStudentId,
          );
        },
        childCount: events.length,
      ),
    );
  }

  Widget _buildImagePreview() {
    return GestureDetector(
      onTap: _hideImagePreview,
      child: Container(
        color: Colors.black.withOpacity(0.9),
        child: Center(
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Image.network(
                _previewImageUrl!,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: _hideImagePreview,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

