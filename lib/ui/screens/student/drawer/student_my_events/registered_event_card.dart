import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../../core/providers/registered_events_provider.dart';
import '../../../../../widgets/animated_status_dot.dart';
import '../../../../../widgets/event_details_page.dart';
import '../../../../../widgets/event_info.dart';

class RegisteredEventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final String studentId;

  const RegisteredEventCard({
    Key? key,
    required this.event,
    required this.studentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime eventDate = DateTime.parse(event['date']);
    final formattedDate = DateFormat('yyyy-MM-dd').format(eventDate);
    final formattedTime = '${event['start_time']}'.substring(0, 5);
    final isAttended = event['attendance'] == 'present';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(
              imageUrl: event['image_url'] ?? '',
              description: event['description'] ?? 'No description available.',
              title: event['title'] ?? '',
              registrations: event['registration_count'],
              club_name: event['club_name'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event['title'] ?? 'Event Title',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.favorite_border,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                  SizedBox(width: 12),
                  Text(
                    '$formattedDate at $formattedTime',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                  SizedBox(width: 12),
                  Text(
                    event['venue'] ?? 'Venue',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.business, color: Colors.grey[600], size: 20),
                  SizedBox(width: 12),
                  Text(
                    event['club_name'] ?? 'Organizer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              if (isAttended)
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Present',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: () => _scanQRCode(context),
                  icon: Icon(Icons.qr_code_scanner,color: Colors.white,),
                  label: Text('Scan QR to Mark Attendance'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B5BFF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _scanQRCode(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => QRScannerPage(
        onScanned: (String? scannedData) {
          Navigator.of(context).pop();
          _processScannedData(context, scannedData);
        },
      ),
    ));
  }

  void _processScannedData(BuildContext context, String? scannedEventId) {
    if (scannedEventId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan QR code')),
      );
      return;
    }

    if (scannedEventId == event['id'].toString()) {
      Provider.of<RegisteredEventsProvider>(context, listen: false)
          .markAttendance(event['id'].toString(), studentId)
          .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance marked successfully')),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to mark attendance: $error')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid QR code for this event')),
      );
    }
  }
}

class QRScannerPage extends StatefulWidget {
  final Function(String?) onScanned;

  const QRScannerPage({Key? key, required this.onScanned}) : super(key: key);

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            widget.onScanned(barcode.rawValue);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

