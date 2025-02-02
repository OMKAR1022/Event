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
  final List<String> _categories = ["Academic", "Cultural", "Sports", "Technical", "Workshop", "Other"];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
    });
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            _buildCategoryTabs(),
            Expanded(
              child: Stack(
                children: [
                  Consumer<StudentEventProvider>(
                    builder: (context, studentEventProvider, child) {
                      if (studentEventProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildEventList(studentEventProvider.events, _categories[_selectedIndex]);
                    },
                  ),
                  if (_previewImageUrl != null)
                    _buildImagePreview(),
                ],
              ),
            ),
          ],
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
            decoration: InputDecoration(
              hintText: "Search events...",
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
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

  Widget _buildEventList(List<Map<String, dynamic>> events, String category) {
    final filteredEvents = events.where((event) => event['category'] == category).toList();

    if (filteredEvents.isEmpty) {
      return Center(
        child: Text(
          'No events available.',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
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

