import 'package:flutter/material.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/registered_events_provider.dart';
import '../../widgets/registered_event_card.dart';

class MyEventsPage extends StatefulWidget {
  final String studentId;

  const MyEventsPage({
    Key? key,
    required this.studentId,
  }) : super(key: key);

  @override
  _MyEventsPageState createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RegisteredEventsProvider>(context, listen: false)
          .fetchRegisteredEvents(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: false,

        title: Text(
          'My Events',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<RegisteredEventsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[200]!),
              ),
            );
          }

          if (provider.registeredEvents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 72,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No Events Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Register for events to see them here',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Browse Events',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.purple[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: provider.registeredEvents.length,
            itemBuilder: (context, index) {
              final event = provider.registeredEvents[index];
              return RegisteredEventCard(
                event: event,
                studentId: widget.studentId,
              );
            },
          );
        },
      ),
    );
  }
}

