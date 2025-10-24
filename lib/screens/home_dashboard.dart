import 'package:flutter/material.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Dashboard')),
      body: const Center(child: Text('Welcome to Fitness Tracker!')),
    );
  }
}
