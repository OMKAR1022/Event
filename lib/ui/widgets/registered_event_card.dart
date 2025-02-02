import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../core/providers/registered_events_provider.dart';

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
    final formattedTime = '${event['start_time']}';

    return Card(
      elevation: 0,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                SizedBox(width: 8),
                Text(
                  '$formattedDate • $formattedTime',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (event['venue'] != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Text(
                    event['venue'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance: ${event['attendance']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: event['attendance'] == 'present' ? Colors.green : Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: event['attendance'] == 'present'
                      ? null
                      : () => _scanQRCode(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  child: Text(event['attendance'] == 'present' ? 'Attended' : 'Mark Attendance'),
                ),
              ],
            ),
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

