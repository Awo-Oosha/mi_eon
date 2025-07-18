import 'package:flutter/material.dart';
import 'package:mi_eon/core/constants/assets.dart';
import 'package:mi_eon/core/constants/colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(AppIcons.menu, color: AppColors.iconColor, size: 24),
          ),
          const Text(
            AppStrings.dashboard,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(AppIcons.alert, color: AppColors.iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
