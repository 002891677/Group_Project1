import 'package:flutter/material.dart';

void main() => runApp(const FitnessTrackerApp());

class FitnessTrackerApp extends StatelessWidget {
  const FitnessTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const Scaffold(body: Center(child: Text('Boot OK - placeholder'))),
      debugShowCheckedModeBanner: false,
    );
  }
}
