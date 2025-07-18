import 'package:flutter/material.dart';
import 'package:mi_eon/core/constants/assets.dart';
import 'package:mi_eon/core/constants/colors.dart';
import 'package:mi_eon/features/fasting/widgets/AppBarWidget.dart';
import 'package:mi_eon/features/fasting/widgets/InfoCard.dart';


class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: HomeBody()
    );
  }
}

class HomeBody extends StatelessWidget{
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 31),
        color: AppColors.background,
        child: Column(
          children: <Widget>[
            InfoCard(
              icon: Icon(AppIcons.clock, size: 44,),
              title: 'Yay, 5 days left for Eid !! 😆',
              description: "congratulations you're not mokel this month",
            )
          ],
        ),
      ),
    );
  }
}
