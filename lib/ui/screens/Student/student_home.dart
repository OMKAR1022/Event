import 'package:flutter/material.dart';
import '../../widgets/category_tabs.dart';
import '../../widgets/student/search_bar.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../core/providers/student_event_provider.dart';

import '../../widgets/student/event_list.dart';
import '../../widgets/student/image_preview.dart';
import '../../widgets/student/offline_message.dart';
import '../../widgets/student/student_app_bar.dart';
import '../../widgets/student/student_drawer.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../utils/network_utils.dart';


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
      duration: Duration(milliseconds: 300),
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
        content: Text(
          hasInternet ? 'Back online' : 'You are offline. Some features may be limited.',
        ),
        duration: Duration(seconds: 3),
        backgroundColor: hasInternet ? Colors.green : Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              StudentAppBar(
                                studentName: widget.studentName ?? 'Student',
                                onMenuPressed: () => Scaffold.of(context).openDrawer(),
                              ),
                              SizedBox(height: 24),
                              SearchBar_student(
                                controller: _searchController,
                                onChanged: (value) => setState(() => _searchQuery = value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: FilterTabs(
                          categories: _categories,
                          selectedIndex: _selectedIndex,
                          onCategorySelected: (index) {
                            setState(() => _selectedIndex = index);
                            /*    _animationController.reset();
                            _animationController.forward();*/
                          },
                        ),
                      ),

                      EventList(
                        selectedCategory: _categories[_selectedIndex],
                        searchQuery: _searchQuery,
                        currentStudentId: widget.currentStudentId,
                        onImageTap: _showImagePreview,
                      ),
                    ],
                  ),
                ),
              if (_previewImageUrl != null)
                ImagePreview(
                  imageUrl: _previewImageUrl!,
                  onClose: _hideImagePreview,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
