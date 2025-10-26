import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class SettingsRemindersScreen extends StatefulWidget {
  const SettingsRemindersScreen({super.key});

  @override
  State<SettingsRemindersScreen> createState() =>
      _SettingsRemindersScreenState();
}

class _SettingsRemindersScreenState extends State<SettingsRemindersScreen> {
  final NotificationService _notif = NotificationService();

  bool _dailyEnabled = false;
  TimeOfDay _dailyTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _notif.initNotification(); // ✅ matches your service
  }

  String _fmt(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final ampm = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _dailyTime,
    );
    if (!mounted) return;

    if (picked != null) {
      setState(() => _dailyTime = picked);
      if (_dailyEnabled) {
        await _scheduleDaily(); // reschedule at new time
      }
    }
  }

  Future<void> _scheduleDaily() async {
    await _notif.scheduleDailyNotification(
      _dailyTime.hour,
      _dailyTime.minute,
      'Daily Reminder',
      'Time to log today’s workout and calories!',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Daily reminder set for ${_fmt(_dailyTime)}')),
    );
  }

  Future<void> _cancelAll() async {
    await _notif.cancelAll();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All reminders cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Daily reminder'),
            subtitle: Text(_dailyEnabled ? 'At ${_fmt(_dailyTime)}' : 'Off'),
            value: _dailyEnabled,
            onChanged: (v) async {
              setState(() => _dailyEnabled = v);
              if (v) {
                await _scheduleDaily();
              } else {
                await _cancelAll();
              }
            },
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Reminder time'),
            subtitle: Text(_fmt(_dailyTime)),
            trailing: TextButton(
              onPressed: _pickTime,
              child: const Text('Change'),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _dailyEnabled ? _scheduleDaily : null,
            icon: const Icon(Icons.notifications_active),
            label: const Text('Reschedule for selected time'),
          ),
          if (_dailyEnabled)
            TextButton(
              onPressed: _cancelAll,
              child: const Text('Cancel reminders'),
            ),
        ],
      ),
    );
  }
}
