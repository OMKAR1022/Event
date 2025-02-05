import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mit_event/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/providers/registered_events_provider.dart';
import 'animated_status_dot.dart';
import 'event_info.dart';

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
    final formattedDate = DateFormat('MMM d, yyyy').format(eventDate);
    final formattedTime = '${event['start_time']}'.substring(0, 5);
    final formattedendtime = '${event['end_time']}'.substring(0, 5);
    final formattedDateTime = '$formattedDate $formattedTime';
    final attendanceStatus = event['attendance'];
    final isAttended = attendanceStatus == 'present';

    return Card(
      color: AppColors.card,
      elevation: 2, // Added elevation for a card-like appearance
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder( // Rounded corners
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Ensures title doesn't overflow
                  child: Text(
                    event['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isAttended)
                  ElevatedButton(
                    onPressed: () => _scanQRCode(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    child: Text('Mark Attendance'),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color:Colors.green,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 1,
                              offset: Offset(-1, 2)
                          )
                        ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedStatusDot(
                          color: Colors.white,
                          isActive: true,
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Present",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )

              ],
            ),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Organized by: ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextSpan(
                    text: '${event['club_name']}',
                    style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            EventInfoCard(
                formattedDate: formattedDate,
                formattedStartTime: '$formattedTime',
                formattedEndTime: '$formattedendtime',
                venue: event['venue']),
            SizedBox(height: 8),



          ],
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

