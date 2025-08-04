// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/countdown_timer.dart';
import 'fasting_settings.dart'; // Make sure you have this screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay start = TimeOfDay(hour: 20, minute: 0);
  TimeOfDay end = TimeOfDay(hour: 12, minute: 0);

  @override
  void initState() {
    super.initState();
    loadTimes();
  }

  Future<void> loadTimes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      start = TimeOfDay(
        hour: prefs.getInt('startHour') ?? 20,
        minute: prefs.getInt('startMinute') ?? 0,
      );
      end = TimeOfDay(
        hour: prefs.getInt('endHour') ?? 12,
        minute: prefs.getInt('endMinute') ?? 0,
      );
    });
  }

  DateTime _getNextDateTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return now.isBefore(dt) ? dt : dt.add(const Duration(days: 1));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startDateTime = _getNextDateTime(start);
    final endDateTime = _getNextDateTime(end);

    // If the fast crosses midnight, fix the logic
    final isFasting = now.isAfter(startDateTime) || now.isBefore(endDateTime);
    final targetTime = isFasting ? endDateTime : startDateTime;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('🕐 Daily Fasting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FastingSettingsScreen()),
              );
              loadTimes(); // Reload on return from settings
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CountdownTimer(endTime: targetTime),
        ),
      ),
    );
  }
}
