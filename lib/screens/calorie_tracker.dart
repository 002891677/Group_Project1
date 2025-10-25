import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class CalorieEntry {
  final int? id;
  final String meal;
  final int calories;
  final DateTime date;

  CalorieEntry({
    this.id,
    required this.meal,
    required this.calories,
    required this.date,
  });
}

class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({super.key});

  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final _mealCtrl = TextEditingController();
  final _calCtrl = TextEditingController();

  final dbHelper = DatabaseHelper();
  final List<CalorieEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadCalories();
  }

  Future<void> _loadCalories() async {
    final data = await dbHelper.getCalories();
    setState(() {
      _entries.clear();
      for (var item in data) {
        _entries.add(
          CalorieEntry(
            id: item['id'],
            meal: item['meal'],
            calories: item['calories'],
            date: DateTime.parse(item['date']),
          ),
        );
      }
    });
  }

  Future<void> _addEntry() async {
    final meal = _mealCtrl.text.trim();
    final cals = int.tryParse(_calCtrl.text.trim());
    if (meal.isEmpty || cals == null) return;

    final id = await dbHelper.insertCalorie({
      'meal': meal,
      'calories': cals,
      'date': DateTime.now().toString(),
    });

    setState(() {
      _entries.insert(
        0,
        CalorieEntry(
          id: id,
          meal: meal,
          calories: cals,
          date: DateTime.now(),
        ),
      );
    });

    _mealCtrl.clear();
    _calCtrl.clear();
  }

  Future<void> _deleteEntry(int id) async {
    await dbHelper.deleteCalorie(id);
    await _loadCalories();
  }

  int get totalCalories =>
      _entries.fold(0, (sum, entry) => sum + entry.calories);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _mealCtrl,
              decoration: const InputDecoration(labelText: 'Meal'),
            ),
            TextField(
              controller: _calCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addEntry,
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 20),
            Text(
              'Total Calories: $totalCalories',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('No calorie entries yet'))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, i) {
                        final e = _entries[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(e.meal),
                            subtitle: Text('${e.calories} cal'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEntry(e.id!),
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
