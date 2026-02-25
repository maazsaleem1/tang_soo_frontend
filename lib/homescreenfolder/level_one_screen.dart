import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

class LevelOneScreen extends StatelessWidget {
  const LevelOneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LevelOneContent();
  }
}

class _LevelOneContent extends StatefulWidget {
  const _LevelOneContent();

  @override
  State<_LevelOneContent> createState() => _LevelOneContentState();
}

class _LevelOneContentState extends State<_LevelOneContent> {
  int _expandedLessonIndex = 0;
  final Set<int> _completedLessons = {};
  static const int _freeTrialLessonCount = 3;

  @override
  Widget build(BuildContext context) {
    final lessons = <String>[
      "Introduction",
      "Pyun Ahn",
      "Positive Mindset",
      "Chop Techniques",
      "Goal Setting",
      "Traditional Breathing Exercises",
      "Punch Techniques",
      "Situational Awareness",
      "Infinity",
      "Chi Gong Tai Chi",
    ];
    final lessonVideos = <String>[
      "assets/video/introductionvideo.mp4",
      "assets/video/introductionvideo.mp4",
      "assets/video/videooftheweek.mp4",
      "assets/video/introductionvideo.mp4",
      "assets/video/videooftheweek.mp4",
      "assets/video/introductionvideo.mp4",
      "assets/video/videooftheweek.mp4",
      "assets/video/introductionvideo.mp4",
      "assets/video/videooftheweek.mp4",
      "assets/video/introductionvideo.mp4",
    ];
    final progressPercent =
        ((_completedLessons.length / lessons.length) * 100)
            .clamp(0, 100)
            .toInt();

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: SvgPicture.asset(SvgIcons.backicon),
                  ),
                  styledText("Level 1", TextType.font16700),
                ],
              ),
              12.verticalSpace,
              styledText("Beginner to Red Belt", TextType.font20700),
              12.verticalSpace,
              Row(
                children: [
                  styledText("Progression", TextType.font12400),
                  const Spacer(),
                  styledText("$progressPercent%", TextType.font12400),
                ],
              ),
              6.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: LinearProgressIndicator(
                  value: _completedLessons.length / lessons.length,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFD9D9D9),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.buttoncolour,
                  ),
                ),
              ),
              12.verticalSpace,
              Expanded(
                child: ListView.builder(
                  itemCount: lessons.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _freeTrialLessonCount) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(0, 6.h, 0, 10.h),
                        child: Center(
                          child: styledText(
                            "Unlock all Lessons only \$4.99/m",
                            TextType.font14500,
                            color: const Color(0xFF9B9B9B),
                          ),
                        ),
                      );
                    }

                    final lessonIndex =
                        index > _freeTrialLessonCount ? index - 1 : index;
                    final isCompleted = _completedLessons.contains(lessonIndex);
                    final isUnlocked = lessonIndex < _freeTrialLessonCount;
                    final isExpanded =
                        _expandedLessonIndex == lessonIndex && isUnlocked;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap:
                                isUnlocked
                                    ? () {
                                      setState(() {
                                        _expandedLessonIndex =
                                            isExpanded ? -1 : lessonIndex;
                                      });
                                    }
                                    : null,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 9.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isUnlocked
                                        ? const Color(0xFFEDEDED)
                                        : const Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(8.r),
                                border:
                                    isExpanded
                                        ? Border.all(
                                          color: AppColors.buttoncolour,
                                        )
                                        : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: styledText(
                                      lessons[lessonIndex],
                                      TextType.font16500,
                                      color:
                                          isUnlocked
                                              ? const Color(0xFF333333)
                                              : const Color(0xFFB5B5B5),
                                    ),
                                  ),
                                  if (!isUnlocked)
                                    const Icon(
                                      Icons.lock,
                                      size: 14,
                                      color: Color(0xFFF7A600),
                                    )
                                  else
                                    Container(
                                      width: 18.w,
                                      height: 18.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isCompleted
                                                ? const Color(0xFF3CB471)
                                                : Colors.transparent,
                                        border: Border.all(
                                          color:
                                              isCompleted
                                                  ? const Color(0xFF3CB471)
                                                  : const Color(0xFFD9D9D9),
                                        ),
                                      ),
                                      child:
                                          isCompleted
                                              ? Icon(
                                                Icons.check,
                                                size: 12.sp,
                                                color: Colors.white,
                                              )
                                              : null,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (isExpanded) ...[
                            8.verticalSpace,
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 8.h),
                              decoration: BoxDecoration(
                                color: AppColors.buttoncolour,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      styledText(
                                        "${lessons[lessonIndex]} Video",
                                        TextType.font14500,
                                        color: Colors.white,
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.bookmark_border,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                  6.verticalSpace,
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: CustomVideoPlayer(
                                      videoSource: lessonVideos[lessonIndex],
                                      isAsset: true,
                                      height: 110.h,
                                      width: double.infinity,
                                      autoPlay: false,
                                      looping: false,
                                      showControls: true,
                                      allowFullScreen: true,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  6.verticalSpace,
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _completedLessons.add(lessonIndex);
                                        if (lessonIndex <
                                            _freeTrialLessonCount - 1) {
                                          _expandedLessonIndex =
                                              lessonIndex + 1;
                                        } else {
                                          _expandedLessonIndex = -1;
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 7.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF3CB471),
                                        borderRadius: BorderRadius.circular(
                                          100.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          styledText(
                                            "Mark as Complete",
                                            TextType.font12400,
                                            color: Colors.white,
                                          ),
                                          6.horizontalSpace,
                                          Icon(
                                            isCompleted
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color: Colors.white,
                                            size: 16.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
