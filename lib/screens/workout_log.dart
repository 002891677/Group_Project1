import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});
  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _nameCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();
  final List<Workout> _workouts = [];

  void _addWorkout() {
    final name = _nameCtrl.text.trim();
    final d = int.tryParse(_durationCtrl.text.trim());
    final r = int.tryParse(_repsCtrl.text.trim());
    if (name.isEmpty || d == null || r == null) return;

    setState(() {
      _workouts
          .add(Workout(name: name, duration: d, reps: r, date: DateTime.now()));
    });
    _nameCtrl.clear();
    _durationCtrl.clear();
    _repsCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Exercise Name')),
            const SizedBox(height: 8),
            TextField(
                controller: _durationCtrl,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Duration (minutes)')),
            const SizedBox(height: 8),
            TextField(
                controller: _repsCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Reps')),
            const SizedBox(height: 12),
            ElevatedButton(
                onPressed: _addWorkout, child: const Text('Add Workout')),
            const SizedBox(height: 12),
            Expanded(
              child: _workouts.isEmpty
                  ? const Center(child: Text('No workouts added yet'))
                  : ListView.builder(
                      itemCount: _workouts.length,
                      itemBuilder: (context, i) {
                        final w = _workouts[i];
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${w.name} – ${w.duration} min – ${w.reps} reps'),
                            subtitle: Text(
                                'Added: ${w.date.toLocal().toString().split(".").first}'),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
