import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';

void main() => runApp(const FitnessTrackerApp());

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const BottomNavController(),
      debugShowCheckedModeBanner: false,
    );
  }
}
