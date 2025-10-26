import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/workout.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});
  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _name = TextEditingController();
  final _sets = TextEditingController();
  final _reps = TextEditingController();
  List<Workout> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await DatabaseHelper.instance.getWorkouts();
    if (!mounted) return;
    setState(() => _items = rows);
  }

  Future<void> _add() async {
    if (_name.text.isEmpty || _sets.text.isEmpty || _reps.text.isEmpty) return;
    await DatabaseHelper.instance.insertWorkout(
      Workout(
        name: _name.text.trim(),
        sets: int.tryParse(_sets.text.trim()) ?? 1,
        reps: int.tryParse(_reps.text.trim()) ?? 1,
        date: DateTime.now(),
      ),
    );
    _name.clear();
    _sets.clear();
    _reps.clear();
    _load();
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.deleteWorkout(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Log')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _name,
                        decoration:
                            const InputDecoration(labelText: 'Workout'))),
                const SizedBox(width: 8),
                SizedBox(
                    width: 80,
                    child: TextField(
                        controller: _sets,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Sets'))),
                const SizedBox(width: 8),
                SizedBox(
                    width: 80,
                    child: TextField(
                        controller: _reps,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Reps'))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Add')),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final w = _items[i];
                return ListTile(
                  title: Text(w.name),
                  subtitle: Text('Sets: ${w.sets}  Reps: ${w.reps}'),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(w.id!)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
