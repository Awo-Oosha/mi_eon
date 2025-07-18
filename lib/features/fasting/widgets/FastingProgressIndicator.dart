import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mi_eon/core/utils.dart';


class FastingProgressIndicator extends StatefulWidget {
  final DateTime fastingStartTime;
  final Duration fastingDuration;

  const FastingProgressIndicator({
    super.key,
    required this.fastingStartTime,
    required this.fastingDuration,
  });

  @override
  State<FastingProgressIndicator> createState() => _FastingProgressIndicatorState();
}

class _FastingProgressIndicatorState extends State<FastingProgressIndicator> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateElapsed();
    _startTimer();
  }

  void _updateElapsed() {
    final now = DateTime.now();
    final elapsed = now.difference(widget.fastingStartTime);
    final totalSeconds = widget.fastingDuration.inSeconds;

    if (elapsed.inSeconds >= totalSeconds) {
      _timer.cancel();
      setState(() {
        _elapsed = Duration(seconds: totalSeconds); // cap at full duration
      });
    } else {
      setState(() {
        _elapsed = elapsed;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateElapsed());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Duration get _remaining => widget.fastingDuration - _elapsed;

  double get _progress {
    final total = widget.fastingDuration.inSeconds;
    final elapsed = _elapsed.inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _progress),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, _) {
        return CustomPaint(
          painter: _GradientProgressPainter(
            progress: value,
            gradientColors: [
              Color(0xFFB4B5F9),
              Color(0xFF6567D9),
              Color(0xFF9B9CF0),
              Color(0xFF8889EC),
              Color(0xFF6567D9),
            ],
            strokeWidth: 35,
          ),
          child: SizedBox(
            width: 300,
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // EudoxusSans
                  Text("Time Remaining",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "EudoxusSans",
                      color: Color(0xFF575757)
                    ),
                  ),
                  gap(7),
                  Text(
                    _progress >= 1.0
                        ? "Done 🎉"
                        : "${_formatDuration(_remaining)} left",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Geist",
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;
  final double strokeWidth;

  _GradientProgressPainter({
    required this.progress,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, backgroundPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: gradientColors,
      stops: [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(-pi / 2),
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(rect, -pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
