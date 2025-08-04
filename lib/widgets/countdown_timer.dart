// widgets/countdown_timer.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'rounded_progress_painter.dart';

class CountdownTimer extends StatefulWidget {
  final DateTime endTime;

  const CountdownTimer({Key? key, required this.endTime}) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemainingTime());
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    setState(() {
      _remaining = widget.endTime.difference(now);
      if (_remaining.isNegative) _remaining = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  double _calculateProgress() {
    final now = DateTime.now();
    final end = widget.endTime;
    final start = end.subtract(const Duration(hours: 16)); // 16-hour fast

    final totalSeconds = end.difference(start).inSeconds;
    final spentSeconds = now.difference(start).inSeconds;
    return (spentSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();

    return Center(
      child: SizedBox(
        height: 240,
        width: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 500),
              builder: (context, value, _) {
                return CustomPaint(
                  painter: RoundedProgressPainter(
                    progress: value,
                    backgroundColor: Colors.grey.shade800,
                    progressColor: Colors.greenAccent,
                    strokeWidth: 12,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatDuration(_remaining),
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  "${(progress * 100).toStringAsFixed(1)}% complete",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
