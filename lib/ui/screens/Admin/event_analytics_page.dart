import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/event_analytics_provider.dart';
import '../../widgets/analytics/analytics_app_bar.dart';
import '../../widgets/analytics/event_info_card.dart';
import '../../widgets/analytics/attendance_stats.dart';
import '../../widgets/analytics/attendance_chart.dart';
import '../../widgets/analytics/action_buttons.dart';
import '../../widgets/analytics/loading_state.dart';
import '../../widgets/analytics/error_state.dart';

class EventAnalyticsPage extends StatelessWidget {
  final String eventId;
  final String eventTitle;

  const EventAnalyticsPage({
    Key? key,
    required this.eventId,
    required this.eventTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: ChangeNotifierProvider(
        create: (_) => EventAnalyticsProvider(eventId),
        child: EventAnalyticsContent(eventTitle: eventTitle),
      ),
    );
  }
}

class EventAnalyticsContent extends StatefulWidget {
  final String eventTitle;

  const EventAnalyticsContent({Key? key, required this.eventTitle}) : super(key: key);

  @override
  _EventAnalyticsContentState createState() => _EventAnalyticsContentState();
}

class _EventAnalyticsContentState extends State<EventAnalyticsContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventAnalyticsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return LoadingState();
        }

        if (provider.error != null) {
          return ErrorState(error: provider.error!);
        }

        return CustomScrollView(
          slivers: [
            AnalyticsAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    EventInfoCard(
                      eventTitle: widget.eventTitle,
                      animation: _fadeAnimation,
                    ),
                    SizedBox(height: 24),
                    AttendanceStats(
                      provider: provider,
                      animation: _fadeAnimation,
                    ),
                    SizedBox(height: 24),
                    AttendanceChart(
                      provider: provider,
                      animation: _fadeAnimation,
                    ),
                    SizedBox(height: 24),
                    ActionButtons(
                      provider: provider,
                      animation: _fadeAnimation,
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

