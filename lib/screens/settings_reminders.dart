import 'package:flutter/material.dart';

class SettingsRemindersScreen extends StatelessWidget {
  const SettingsRemindersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings & Reminders')),
    body: const Center(child: Text('Notifications & preferences')),
  );
}
