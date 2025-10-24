import 'package:flutter/material.dart';
import '../screens/home_dashboard.dart';
import '../screens/workout_log.dart';
import '../screens/calorie_tracker.dart';
import '../screens/progress_tracker.dart';
import '../screens/settings_reminders.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});
  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeDashboard(),
    WorkoutLogScreen(),
    CalorieTrackerScreen(),
    ProgressTrackerScreen(),
    SettingsRemindersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_dining),
            label: 'Calories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
