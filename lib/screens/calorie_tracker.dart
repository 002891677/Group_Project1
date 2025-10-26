import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/calorie_entry.dart';

class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({super.key});
  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final _item = TextEditingController();
  final _cal = TextEditingController();
  List<CalorieEntry> _items = [];
  int _todayTotal = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = DatabaseHelper.instance;
    final list = await db.getCalories();
    final t = await db.totalCaloriesForDate(DateTime.now());
    if (!mounted) return;
    setState(() {
      _items = list;
      _todayTotal = t;
    });
  }

  Future<void> _add() async {
    if (_item.text.isEmpty || _cal.text.isEmpty) return;
    await DatabaseHelper.instance.insertCalorie(
      CalorieEntry(
          item: _item.text.trim(),
          calories: int.tryParse(_cal.text.trim()) ?? 0,
          date: DateTime.now()),
    );
    _item.clear();
    _cal.clear();
    _load();
  }

  Future<void> _delete(int id) async {
    await DatabaseHelper.instance.deleteCalorie(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Tracker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: _item,
                        decoration: const InputDecoration(labelText: 'Item'))),
                const SizedBox(width: 8),
                SizedBox(
                    width: 100,
                    child: TextField(
                        controller: _cal,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: 'Calories'))),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _add, child: const Text('Add')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Today: $_todayTotal kcal',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const Divider(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 0),
              itemBuilder: (context, i) {
                final c = _items[i];
                return ListTile(
                  title: Text(c.item),
                  subtitle: Text(
                      '${c.calories} kcal • ${c.date.toLocal().toString().split(' ').first}'),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _delete(c.id!)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
