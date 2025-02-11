import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mit_event/utils/screen_size.dart';
import '../../../core/providers/event_analytics_provider.dart';

class AttendanceChart extends StatelessWidget {
  final EventAnalyticsProvider provider;
  final Animation<double> animation;

  const AttendanceChart({
    Key? key,
    required this.provider,
    required this.animation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (provider.totalStudents == 0) {
      return _buildEmptyState();
    }

    final presentPercentage = (provider.presentStudents / provider.totalStudents * 100).round();
    final absentPercentage = 100 - presentPercentage;

    return FadeTransition(
      opacity: animation,
      child: Container(
        height: 400,
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green[400],
                      value: provider.presentStudents.toDouble(),
                      title: '$presentPercentage%',
                      radius: 80,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.red[400],
                      value: provider.absentStudents.toDouble(),
                      title: '$absentPercentage%',
                      radius: 80,
                      titleStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Present', presentPercentage, Colors.green[400]!),
                SizedBox(width: 24),
                _buildLegendItem('Absent', absentPercentage, Colors.red[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      width: 500,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No attendance data available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start taking attendance to see analytics',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, int percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(
          '$label ($percentage%)',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

