import 'package:flutter/material.dart';

class CalorieTrackerScreen extends StatelessWidget {
  const CalorieTrackerScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Calorie Tracker')),
    body: const Center(child: Text('Calorie entry form here')),
  );
}
