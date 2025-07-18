import 'package:flutter/material.dart';
import 'package:mi_eon/core/constants/colors.dart';
import 'package:mi_eon/core/utils.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;
  final VoidCallback? buttonClick;
  final String? buttonText;

  const InfoCard({
    super.key,
    this.icon,
    this.buttonClick,
    this.buttonText,
    required this.title,
    required this.description
  });

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
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (icon != null) icon!,
            gap(28),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      fontFamily: 'EudoxusSans'
                    ),
                  ),
                  gap(5),
                  Text(description,
                    style: TextStyle(
                      color: AppColors.subText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Geist'
                    ),
                  )
                ],
              ),
            ),

            if (buttonText != null && buttonClick != null) ...[
              gap(28),
              TextButton(onPressed: buttonClick, child: Text(buttonText!)),
            ],
          ],
        ),
      ),
    );
  }
}