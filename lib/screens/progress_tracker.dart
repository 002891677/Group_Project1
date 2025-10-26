import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});
  @override
  State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
  int _todayCalories = 0;
  int _todayWorkouts = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = DatabaseHelper.instance;
    final today = DateTime.now();
    final cals = await db.totalCaloriesForDate(today);
    final w = await db.totalWorkoutsForDate(today);
    if (!mounted) return;
    setState(() {
      _todayCalories = cals;
      _todayWorkouts = w;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _tile('Today’s calories', '$_todayCalories kcal',
                Icons.local_fire_department),
            const SizedBox(height: 12),
            _tile('Today’s workouts', '$_todayWorkouts', Icons.fitness_center),
            const SizedBox(height: 24),
            const Text('Tip: pull to refresh',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _tile(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12)),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
