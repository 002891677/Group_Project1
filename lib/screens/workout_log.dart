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
    if (name.isEmpty || d == null || r == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields properly')),
      );
      return;
    }

    setState(() {
      _workouts.add(
        Workout(name: name, duration: d, reps: r, date: DateTime.now()),
      );
    });

    _nameCtrl.clear();
    _durationCtrl.clear();
    _repsCtrl.clear();
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workout deleted')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Log')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- INPUT FIELDS ----------
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Exercise Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _durationCtrl,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Duration (minutes)'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _repsCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Reps'),
            ),
            const SizedBox(height: 12),

            // ---------- ADD BUTTON ----------
            ElevatedButton(
              onPressed: _addWorkout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Add Workout', style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 16),
            const Divider(),

            // ---------- PRESET ROUTINES ----------
            const Text(
              'Preset Routines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const ListTile(
              title: Text('Beginner'),
              subtitle: Text('Push-ups 3×10 • Squats 3×15 • Plank 3×30s'),
            ),
            const ListTile(
              title: Text('Intermediate'),
              subtitle: Text('Burpees 3×12 • Lunges 3×15 • Crunches 3×20'),
            ),
            const ListTile(
              title: Text('Advanced'),
              subtitle: Text(
                  'Pull-ups 3×8 • Deadlifts 3×10 • Mountain Climbers 3×30s'),
            ),

            const Divider(),
            const SizedBox(height: 8),

            // ---------- WORKOUT LIST ----------
            const Text(
              'Your Workouts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _workouts.isEmpty
                  ? const Center(child: Text('No workouts added yet'))
                  : ListView.builder(
                      itemCount: _workouts.length,
                      itemBuilder: (context, i) {
                        final w = _workouts[i];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              '${w.name} – ${w.duration} min – ${w.reps} reps',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              'Added: ${w.date.toLocal().toString().split(".").first}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteWorkout(i),
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
