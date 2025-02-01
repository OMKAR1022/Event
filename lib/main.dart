import 'package:flutter/material.dart';
import 'package:mit_event/ui/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/providers/club_profile_provider.dart';
import 'core/providers/event_creation_provider.dart';
import 'core/providers/event_provider.dart';
import 'core/providers/login_provider.dart';
import 'core/providers/event_registration_provider.dart';
import 'core/providers/student_event_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zgnmnqzkqzxbsisfpfkd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpnbm1ucXprcXp4YnNpc2ZwZmtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU4OTM2ODEsImV4cCI6MjA1MTQ2OTY4MX0.Szf4o2hcTXsXor5LP7M0z5q9oLLlsp08N9M7xLRKjWo',
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (_) => EventRegistrationProvider()),
        ChangeNotifierProvider(create: (_) => EventCreationProvider()),
        ChangeNotifierProvider(create: (_) => StudentEventProvider()),
        ChangeNotifierProvider(create: (_) => ClubProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(), // Entry screen
      ),
    );
  }
}




