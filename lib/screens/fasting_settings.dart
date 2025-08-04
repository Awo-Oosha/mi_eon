import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';


class FastingSettingsScreen extends StatefulWidget {
  const FastingSettingsScreen({Key? key}) : super(key: key);

  @override
  _FastingSettingsScreenState createState() => _FastingSettingsScreenState();
}

class _FastingSettingsScreenState extends State<FastingSettingsScreen> {
  TimeOfDay _start = TimeOfDay(hour: 20, minute: 0);
  TimeOfDay _end = TimeOfDay(hour: 12, minute: 0);

  Future<void> _loadTimes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _start = TimeOfDay(
          hour: prefs.getInt('startHour') ?? 20,
          minute: prefs.getInt('startMinute') ?? 0);
      _end = TimeOfDay(
          hour: prefs.getInt('endHour') ?? 12,
          minute: prefs.getInt('endMinute') ?? 0);
    });
  }

  Future<void> _saveTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('startHour', _start.hour);
    await prefs.setInt('startMinute', _start.minute);
    await prefs.setInt('endHour', _end.hour);
    await prefs.setInt('endMinute', _end.minute);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _start : _end,
    );
    if (picked != null) {
      setState(() {
        if (isStart) _start = picked;
        else _end = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fasting Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Start Time'),
              subtitle: Text(_start.format(context)),
              trailing: Icon(Icons.edit),
              onTap: () => _pickTime(true),
            ),
            ListTile(
              title: Text('End Time'),
              subtitle: Text(_end.format(context)),
              trailing: Icon(Icons.edit),
              onTap: () => _pickTime(false),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _saveTimes();
                await NotificationService.scheduleNotification(_start, 'Fasting has started!', 1);
                await NotificationService.scheduleNotification(_end, 'Fasting ended, you can eat now!', 2);
                Navigator.pop(context);
              },
              child: Text('Save & Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
