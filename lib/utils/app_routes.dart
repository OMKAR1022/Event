import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/Admin/admin_hoem.dart';
import 'package:mit_event/ui/screens/Student/student_home.dart';

import '../auth/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String adminHome = '/admin-home';
  static const String studentHome = '/student-home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      adminHome: (context) => AdminHome(
        clubName: ModalRoute.of(context)!.settings.arguments as String,
        clubId: '',
        totalEvents: 0,
      ),
      studentHome: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return StudentHome(
          currentStudentId: args['currentStudentId'],
          studentName: args['studentName'],
          enrollmentNo: args['enrollmentNo'],
          email: args['email'],
          phoneNo: args['phoneNo'],
        );
      },
    };
  }
}
