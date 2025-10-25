import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class Workout {
  final int? id;
  final String name;
  final int duration;
  final int reps;
  final DateTime date;

  Workout({
    this.id,
    required this.name,
    required this.duration,
    required this.reps,
    required this.date,
  });
}

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _nameCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _repsCtrl = TextEditingController();

  final dbHelper = DatabaseHelper();
  final List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final data = await dbHelper.getWorkouts();
    setState(() {
      _workouts.clear();
      for (var item in data) {
        _workouts.add(
          Workout(
            id: item['id'],
            name: item['name'],
            duration: item['duration'],
            reps: item['reps'],
            date: DateTime.parse(item['date']),
          ),
        );
      }
    });
  }

  Future<void> _addWorkout() async {
    final name = _nameCtrl.text.trim();
    final duration = int.tryParse(_durationCtrl.text.trim());
    final reps = int.tryParse(_repsCtrl.text.trim());
    if (name.isEmpty || duration == null || reps == null) return;

    final id = await dbHelper.insertWorkout({
      'name': name,
      'duration': duration,
      'reps': reps,
      'date': DateTime.now().toString(),
    });

    setState(() {
      _workouts.insert(
        0,
        Workout(
          id: id,
          name: name,
          duration: duration,
          reps: reps,
          date: DateTime.now(),
        ),
      );
    });

    _nameCtrl.clear();
    _durationCtrl.clear();
    _repsCtrl.clear();
  }

  Future<void> _deleteWorkout(int id) async {
    await dbHelper.deleteWorkout(id);
    await _loadWorkouts();
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
              decoration: const InputDecoration(labelText: 'Exercise Name'),
            ),
            TextField(
              controller: _durationCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (min)'),
            ),
            TextField(
              controller: _repsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addWorkout,
              child: const Text('Add Workout'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _workouts.isEmpty
                  ? const Center(child: Text('No workouts yet'))
                  : ListView.builder(
                      itemCount: _workouts.length,
                      itemBuilder: (context, i) {
                        final w = _workouts[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(w.name),
                            subtitle: Text(
                                'Duration: ${w.duration} min | Reps: ${w.reps}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteWorkout(w.id!),
                            ),
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
