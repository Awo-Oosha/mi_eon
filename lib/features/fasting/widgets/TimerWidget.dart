import 'package:flutter/material.dart';
import 'package:mi_eon/core/constants/colors.dart';
import 'package:mi_eon/core/utils.dart';
import 'FastingProgressIndicator.dart';

class TimerWidget extends StatelessWidget{
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1, // Shadow depth
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Ramadhan Fasting",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'EudoxusSans',
                fontWeight: FontWeight.w700,
                fontFeatures: [
                  FontFeature.liningFigures(),
                  FontFeature.proportionalFigures()
                ]
              ),
            ),
            
            gap(24, vertical: true),

            FastingProgressIndicator(
              fastingDuration: const Duration(hours: 1),
              fastingStartTime: DateTime.now().subtract(const Duration(minutes: 4)),
            ),

          ],
        ),
      ),
    );
  }
}