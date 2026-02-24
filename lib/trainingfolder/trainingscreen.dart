import 'package:flutter/material.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class Trainingscreen extends StatefulWidget {
  const Trainingscreen({super.key});

  @override
  State<Trainingscreen> createState() => TrainingscreenState();
}

class TrainingscreenState extends State<Trainingscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: Container(child: Text("hello"),),
    );
  }
}
