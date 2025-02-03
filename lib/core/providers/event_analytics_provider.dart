import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class EventAnalyticsProvider with ChangeNotifier {
  final String eventId;
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _studentAttendance = [];
  int _totalStudents = 0;
  int _presentStudents = 0;
  int _absentStudents = 0;

  EventAnalyticsProvider(this.eventId) {
    _fetchEventAnalytics();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get studentAttendance => _studentAttendance;
  int get totalStudents => _totalStudents;
  int get presentStudents => _presentStudents;
  int get absentStudents => _absentStudents;

  Future<void> _fetchEventAnalytics() async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('event_registrations')
          .select('''
            id,
            student_id,
            attendance,
            student_user (
              name,
              enroll_no,
              phone_no,
              email
            )
          ''')
          .eq('event_id', eventId);

      _studentAttendance = List<Map<String, dynamic>>.from(response);

      _totalStudents = _studentAttendance.length;
      _presentStudents = _studentAttendance.where((s) => s['attendance'] == 'present').length;
      _absentStudents = _totalStudents - _presentStudents;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching event analytics: $e');
      _error = 'Failed to fetch event analytics: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> generateAndShareExcelFile() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Present Students'];

      // Add headers
      sheetObject.appendRow([
        TextCellValue('Name'),
        TextCellValue('Enrollment No'),
        TextCellValue('Phone No'),
        TextCellValue('Email')
      ]);

      // Add data
      for (var student in _studentAttendance) {
        if (student['attendance'] == 'present') {
          var userData = student['student_user'];
          sheetObject.appendRow([
            TextCellValue(userData['name'] ?? ''),
            TextCellValue(userData['enroll_no'] ?? ''),
            TextCellValue(userData['phone_no'] ?? ''),
            TextCellValue(userData['email'] ?? ''),
          ]);
        }
      }

      // Save the excel file
      var fileBytes = excel.save();
      var directory = await getTemporaryDirectory();
      File file = File('${directory.path}/present_students.xlsx');
      await file.writeAsBytes(fileBytes!);

      // Share the file
      final result = await Share.shareXFiles([XFile(file.path)], text: 'Present Students Excel File');

      if (result.status == ShareResultStatus.success) {
        return file.path;
      } else {
        print('Share canceled or failed: ${result.status}');
        return null;
      }
    } catch (e) {
      print('Error generating or sharing Excel file: $e');
      return null;
    }
  }
}

