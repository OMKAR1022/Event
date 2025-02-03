import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/providers/event_analytics_provider.dart';
import 'package:open_file/open_file.dart';

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
      appBar: AppBar(
        title: Text('Event Analytics'),
        backgroundColor: Colors.blue[800],
      ),
      body: ChangeNotifierProvider(
        create: (_) => EventAnalyticsProvider(eventId),
        child: EventAnalyticsContent(eventTitle: eventTitle),
      ),
    );
  }
}

class EventAnalyticsContent extends StatelessWidget {
  final String eventTitle;

  const EventAnalyticsContent({Key? key, required this.eventTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EventAnalyticsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text('Error: ${provider.error}'));
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventTitle,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 24),
              _buildAttendanceOverview(provider),
              SizedBox(height: 32),
              _buildAttendanceChart(provider),
              SizedBox(height: 32),
              _buildDownloadButton(context, provider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceOverview(EventAnalyticsProvider provider) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewItem('Total', provider.totalStudents, Colors.blue),
              _buildOverviewItem('Present', provider.presentStudents, Colors.green),
              _buildOverviewItem('Absent', provider.absentStudents, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAttendanceChart(EventAnalyticsProvider provider) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[800]),
          ),
          SizedBox(height: 16),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: provider.presentStudents.toDouble(),
                    title: 'Present',
                    radius: 100,
                    titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: provider.absentStudents.toDouble(),
                    title: 'Absent',
                    radius: 100,
                    titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
                sectionsSpace: 0,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, EventAnalyticsProvider provider) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.share),
        label: Text('Share Present Students Excel'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () async {
          try {
            final filePath = await provider.generateAndShareExcelFile();
            if (filePath != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Excel file generated and shared successfully')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to share Excel file. Please try again.')),
              );
            }
          } catch (e) {
            print('Error in share button: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred while sharing the file: $e')),
            );
          }
        },
      ),
    );
  }
}

