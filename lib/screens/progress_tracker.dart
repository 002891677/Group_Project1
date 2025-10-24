import 'package:flutter/material.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});

  @override
  State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
  // Dummy weekly data (Mon..Sun). You can wire real data later.
  final List<int> weeklyCalories = [1200, 1500, 900, 1800, 1600, 2000, 1700];
  final List<int> weeklyWorkouts = [1, 2, 0, 2, 1, 3, 2];
  final List<String> days = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  int get totalCalories => weeklyCalories.fold(0, (sum, v) => sum + v);

  double get avgCalories =>
      weeklyCalories.isEmpty ? 0 : totalCalories / weeklyCalories.length;

  int get totalWorkouts => weeklyWorkouts.fold(0, (sum, v) => sum + v);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Calorie Progress',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Calorie bars
            Expanded(
              child: ListView.separated(
                itemCount: days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final value = weeklyCalories[i].clamp(0, 2400);
                  final pct = value / 2400.0; // 2400 as a reference daily goal
                  return Row(
                    children: [
                      SizedBox(width: 36, child: Text(days[i])),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 10,
                            backgroundColor: Colors.grey[300],
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${weeklyCalories[i]} cal'),
                    ],
                  );
                },
              ),
            ),

            const Divider(height: 32),

            // Summary
            const Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Total calories this week: $totalCalories'),
            Text('Average per day: ${avgCalories.toStringAsFixed(0)} cal'),
            Text('Total workouts: $totalWorkouts'),
          ],
        ),
      ),
    );
  }
}
