import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';

// Notifications + timezone init
import 'services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

final NotificationService _notificationService = NotificationService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone DB (required for zonedSchedule).
  tz.initializeTimeZones();

  // Initialize flutter_local_notifications once at app start.
  await _notificationService.initNotification();

  runApp(const FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      home: const BottomNavController(),
      debugShowCheckedModeBanner: false,
    );
  }
}
