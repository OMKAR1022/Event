import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/category_tabs.dart';

import '../../widgets/student/search_bar.dart';
import '../../../utils/app_colors.dart';
import '../../../core/providers/student_event_provider.dart';
import '../../widgets/student/event_list.dart';
import '../../widgets/student/image_preview.dart';
import '../../widgets/student/offline_message.dart';
import '../../widgets/student/student_app_bar.dart';
import '../../widgets/student/student_drawer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../utils/network_utils.dart';
import 'dart:async';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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

class _StudentHomeState extends State<StudentHome> with TickerProviderStateMixin {
  String? _previewImageUrl;
  final List<String> _categories = ["All", "Academic", "Cultural", "Sports", "Technical", "Workshop", "Other"];
  int _selectedIndex = 0;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasInternet = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _connectivitySubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _showImagePreview(String imageUrl) {
    print("Image tapped with URL: $imageUrl"); // Debugging
    setState(() {
      _previewImageUrl = imageUrl;
    });
  }

  void _hideImagePreview() {
    setState(() {
      _previewImageUrl = null;
    });
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
        content: Row(
          children: [
            Icon(hasInternet ? Icons.wifi : Icons.wifi_off, color: Colors.white),
            SizedBox(width: 8),
            Text(
              hasInternet ? 'Back online' : 'You are offline. Some features may be limited.',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        duration: Duration(seconds: 3),
        backgroundColor: hasInternet ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        drawer: StudentDrawer(
          studentName: widget.studentName,
          enrollmentNo: widget.enrollmentNo,
          email: widget.email,
          phoneNo: widget.phoneNo,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              if (!_hasInternet)
                OfflineMessage(onRetry: () async {
                  await _checkConnectivity();
                  if (_hasInternet) {
                    Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
                  }
                })
              else
                RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<StudentEventProvider>(context, listen: false).fetchAllEvents();
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1E88E5), Color(0xFF1565C0)],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: StudentAppBar(
                                  studentName: widget.studentName ?? 'Student',
                                  onMenuPressed: () => Scaffold.of(context).openDrawer(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: SearchBar_student(
                                  controller: _searchController,
                                  onChanged: (value) => setState(() => _searchQuery = value),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                          child: FilterTabs(
                            categories: _categories,
                            selectedIndex: _selectedIndex,
                            onCategorySelected: (index) {
                              setState(() => _selectedIndex = index);
                            },
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        sliver: AnimationLimiter(
                          child: EventList(
                            selectedCategory: _categories[_selectedIndex],
                            searchQuery: _searchQuery,
                            currentStudentId: widget.currentStudentId,
                            onImageTap: _showImagePreview,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_previewImageUrl != null)
                ImagePreview(
                  imageUrl: _previewImageUrl!,
                 // onClose: _hideImagePreview,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

