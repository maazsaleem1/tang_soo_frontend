import 'package:flutter/material.dart';
import 'package:tang_soo_karate/homescreenfolder/belt_lessons_screen.dart';

/// Same flow as [LevelOneScreen] — used when entering a belt from plan level 2.
class LevelTwoScreen extends StatelessWidget {
  const LevelTwoScreen({
    super.key,
    required this.beltId,
    required this.beltTitle,
  });

  final int beltId;
  final String beltTitle;

  @override
  Widget build(BuildContext context) {
    return BeltLessonsScreen(beltId: beltId, beltTitle: beltTitle);
  }
}
