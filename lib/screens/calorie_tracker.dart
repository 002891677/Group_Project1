import 'package:flutter/material.dart';
import '../models/calorie_entry.dart';

class CalorieTrackerScreen extends StatefulWidget {
  const CalorieTrackerScreen({super.key});

  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final _mealCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final List<CalorieEntry> _entries = [];

  void _addEntry() {
    final meal = _mealCtrl.text.trim();
    final cals = int.tryParse(_calCtrl.text.trim());
    if (meal.isEmpty || cals == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter meal and calories')),
      );
      return;
    }

    setState(() {
      _entries
          .add(CalorieEntry(meal: meal, calories: cals, date: DateTime.now()));
    });

    _mealCtrl.clear();
    _calCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calorie Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _mealCtrl,
              decoration: const InputDecoration(labelText: 'Meal'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _calCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _addEntry,
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Entries:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: _entries.isEmpty
                  ? const Center(child: Text('No entries yet'))
                  : ListView.builder(
                      itemCount: _entries.length,
                      itemBuilder: (context, i) {
                        final e = _entries[i];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text('${e.meal} – ${e.calories} cal'),
                            subtitle: Text(
                                'Added: ${e.date.toLocal().toString().split(".").first}'),
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
