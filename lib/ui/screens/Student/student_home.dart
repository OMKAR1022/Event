import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/student_event_provider.dart';
import '../../widgets/event_card.dart';

class StudentHome extends StatefulWidget {
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
              Text(
                'Hello, Student!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage('https://hebbkx1anhila5yf.public.blob.vercel-storage.com/Screenshot%202025-01-31%20at%204.58.16%E2%80%AFPM-1Cjnvj699EIFjWf2v8Soiow5UoRkLw.png'),
                radius: 20,
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

