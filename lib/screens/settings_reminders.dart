import 'package:flutter/material.dart';

class SettingsRemindersScreen extends StatefulWidget {
  const SettingsRemindersScreen({super.key});

  @override
  State<SettingsRemindersScreen> createState() =>
      _SettingsRemindersScreenState();
}

class _SettingsRemindersScreenState extends State<SettingsRemindersScreen> {
  bool reminderEnabled = false;
  TimeOfDay? reminderTime;
  bool calorieGoalEnabled = false;
  int calorieGoal = 2000;

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: reminderTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => reminderTime = time);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reminder set to ${time.format(context)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Reminders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Enable Workout Reminder'),
            value: reminderEnabled,
            onChanged: (v) => setState(() => reminderEnabled = v),
          ),
          if (reminderEnabled) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                reminderTime == null
                    ? 'No reminder time set'
                    : 'Reminder time: ${reminderTime!.format(context)}',
              ),
              trailing: ElevatedButton(
                onPressed: _pickTime,
                child: const Text('Pick Time'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          const Divider(),
          SwitchListTile(
            title: const Text('Enable Daily Calorie Goal'),
            value: calorieGoalEnabled,
            onChanged: (v) => setState(() => calorieGoalEnabled = v),
          ),
          if (calorieGoalEnabled)
            Row(
              children: [
                const Text('Goal:'),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: calorieGoal.toDouble(),
                    min: 1200,
                    max: 3500,
                    divisions: 23,
                    label: '$calorieGoal',
                    onChanged: (v) => setState(() => calorieGoal = v.round()),
                  ),
                ),
                SizedBox(width: 72, child: Text('$calorieGoal cal')),
              ],
            ),
          const SizedBox(height: 8),
          const Text(
            'Note: This screen only stores state in-memory for now. '
            'We can wire Local Notifications and persistent storage (SQLite) as a bonus later.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
