import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _NextLessonItem {
  final int number;
  final String title;
  final bool locked;
  final bool heavyBlur;

  const _NextLessonItem({
    required this.number,
    required this.title,
    this.locked = true,
    this.heavyBlur = false,
  });
}

class _ProgressScreenState extends State<ProgressScreen> {
  static const String _lorem =
      "consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
  static const String _thumbAsset = "assets/images/splashscreen.png";

  /// Current lesson title (e.g. last completed / current focus).
  static const String _currentLessonTitle = "2. Lesson of the Week: Pyung Ahn";

  static const int _lessonsCompleted = 2;
  static const int _lessonsTotal = 52;
  static const double _progressionPercent = 0.05;

  static const List<_NextLessonItem> _nextLessons = [
    _NextLessonItem(
      number: 3,
      title: "Positive Mindset",
      locked: false,
    ),
    _NextLessonItem(number: 4, title: "Chop Techniques", locked: true),
    _NextLessonItem(number: 5, title: "Goal Setting", locked: true),
    _NextLessonItem(
      number: 6,
      title: "Traditional Breathing Exercises",
      locked: true,
    ),
    _NextLessonItem(number: 7, title: "Punch Techniques", locked: true),
    _NextLessonItem(
      number: 8,
      title: "Situational Awareness",
      locked: true,
      heavyBlur: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pctLabel = (_progressionPercent * 100).toInt().toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText(
                "Current Level 1",
                TextType.font12400,
                color: const Color(0xFF9B9B9B),
              ),
              8.verticalSpace,
              styledText(
                _currentLessonTitle,
                TextType.font16600,
                color: const Color(0xFF333333),
                fontWeight: FontWeight.w700,
              ),
              14.verticalSpace,
              Row(
                children: [
                  styledText(
                    "Lessons Completed",
                    TextType.font12400,
                    color: const Color(0xFF9B9B9B),
                  ),
                  const Spacer(),
                  styledText(
                    "$_lessonsCompleted/$_lessonsTotal",
                    TextType.font16500,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              12.verticalSpace,
              Row(
                children: [
                  styledText(
                    "Progression",
                    TextType.font14500,
                    fontWeight: FontWeight.w700,
                  ),
                  const Spacer(),
                  styledText(
                    "$pctLabel%",
                    TextType.font14500,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              6.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: LinearProgressIndicator(
                  value: _progressionPercent,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFD9D9D9),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE53935),
                  ),
                ),
              ),
              8.verticalSpace,
              styledText(
                "You're $pctLabel% closer to your next level!",
                TextType.font12400,
                color: const Color(0xFF9B9B9B),
              ),
              22.verticalSpace,
              styledText("Next Lesson", TextType.font20700),
              12.verticalSpace,
              ..._nextLessons.map(_lessonCard),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lessonCard(_NextLessonItem item) {
    final locked = item.locked;
    final heavyBlur = item.heavyBlur;

    final titleColor =
        heavyBlur
            ? const Color(0xFFC8C8C8)
            : locked
            ? const Color(0xFF757575)
            : const Color(0xFF333333);
    final descColor =
        heavyBlur
            ? const Color(0xFFD0D0D0)
            : const Color(0xFF8A8A8A);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              locked
                  ? null
                  : () {
                    Get.to(
                      () => const LevelOneScreen(
                        beltId: 1,
                        beltTitle: 'Video Of The Week',
                      ),
                    );
                  },
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _thumbnail(locked: locked, heavyBlur: heavyBlur),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styledText(
                          "${item.number}. ${item.title}",
                          TextType.minifont16600hard,
                          color: titleColor,
                        ),
                        4.verticalSpace,
                        styledText(
                          _lorem,
                          TextType.font12400,
                          color: descColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  6.horizontalSpace,
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child:
                        locked
                            ? Icon(
                              Icons.lock_rounded,
                              size: 20.sp,
                              color: const Color(0xFFF7A600),
                            )
                            : _tealContinueGlyph(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumbnail({required bool locked, required bool heavyBlur}) {
    final thumbWidth = 108.w;
    final thumbHeight = thumbWidth * 9 / 16;

    Widget image = Image.asset(
      _thumbAsset,
      width: thumbWidth,
      height: thumbHeight,
      fit: BoxFit.cover,
      errorBuilder:
          (_, __, ___) => Container(
            width: thumbWidth,
            height: thumbHeight,
            color: const Color(0xFF5C5C5C),
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white54,
              size: 32.sp,
            ),
          ),
    );

    if (heavyBlur) {
      image = ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: image,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: thumbWidth,
        height: thumbHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            image,
            if (locked && !heavyBlur)
              Container(color: Colors.black.withValues(alpha: 0.42)),
            if (locked && heavyBlur)
              Container(color: Colors.black.withValues(alpha: 0.28)),
            Positioned(
              right: 6.w,
              bottom: 5.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: styledText(
                  "08:02",
                  TextType.font10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tealContinueGlyph() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.arrow_forward_rounded,
          color: AppColors.buttoncolour,
          size: 20.sp,
        ),
        Container(
          width: 2.5.w,
          height: 16.h,
          margin: EdgeInsets.only(left: 1.w),
          decoration: BoxDecoration(
            color: AppColors.buttoncolour,
            borderRadius: BorderRadius.circular(1.r),
          ),
        ),
      ],
    );
  }
}
