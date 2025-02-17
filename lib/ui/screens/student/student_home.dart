import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/student/profile/student_profile_page.dart';
import 'package:mit_event/ui/screens/student/widget/student_app_bar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../core/providers/student_event_provider.dart';
import '../../../utils/network_utils.dart';
import '../../../widgets/custom_bottom_bar.dart';
import '../../../widgets/offline_message.dart';
import '../Student/widget/student_notification_page.dart';
import 'drawer/student_my_events/my_events_page.dart';
import 'widget/student_event_card/event_list.dart';


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
  final List<String> _categories = ["All Events", "Technology", "Sports", "Arts", "Academic", "Cultural"];
  int _selectedIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasInternet = true;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    _hasInternet = await NetworkUtils.hasInternetConnection();
    setState(() {});
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) async {
    bool hasInternet = result.isNotEmpty && result.first != ConnectivityResult.none;
    if (hasInternet != _hasInternet) {
      setState(() {
        _hasInternet = hasInternet;
      });
      if (hasInternet) {
        await Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
      }
      _showConnectivitySnackBar(hasInternet);
    }
  }

  void _showConnectivitySnackBar(bool hasInternet) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hasInternet ? 'Back online' : 'You are offline. Some features may be limited.',
        ),
        duration: Duration(seconds: 3),
        backgroundColor: hasInternet ? Colors.green : Colors.red,
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
       StudentAppBar(

       ),
        if (!_hasInternet)
          OfflineMessage(onRetry: () async {
            await _checkConnectivity();
            if (_hasInternet) {
              Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
            }
          })
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeSection(),
                    _buildSearchBar(),
                    _buildCategoryTabs(),
                    _buildQuickAccessCards(),
                    _buildUpcomingEventsSection(),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: IndexedStack(
          index: _currentNavIndex,
          children: [
            _buildMainContent(),
            MyEventsPage(studentId: widget.currentStudentId ?? ''),
            StudentProfilePage()
            // Add other pages as needed
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        type: BottomBarType.student,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'logo',
            style: TextStyle(
              color: Colors.blue[700],
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.studentName ?? 'Student',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: ExactAssetImage('assets/images/avatar2.png'),
            radius: 25,
            backgroundColor: Colors.grey[200],
            //child: Image.asset('assets/images/avatar2.png'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search events...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue[700] : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickAccessCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickAccessCard(
              icon: Icons.calendar_today_outlined,
              title: 'My Events',
              subtitle: '5 Upcoming',
              color: Colors.blue[50]!,
              iconColor: Colors.blue[700]!,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildQuickAccessCard(
              icon: Icons.person_outline,
              title: 'Attendance',
              subtitle: 'Mark Present',
              color: Colors.orange[50]!,
              iconColor: Colors.orange[700]!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          EventList(
            selectedCategory: _categories[_selectedIndex],
            searchQuery: _searchQuery,
            currentStudentId: widget.currentStudentId,
            onImageTap: _showImagePreview,
          ),
        ],
      ),
    );
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
}

