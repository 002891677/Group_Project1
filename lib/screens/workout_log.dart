import 'package:flutter/material.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});
  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Log')),
      body: const Center(child: Text('Workout list & form here')),
    );
  }
}
