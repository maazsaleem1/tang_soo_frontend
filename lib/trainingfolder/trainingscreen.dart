import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class Trainingscreen extends StatefulWidget {
  const Trainingscreen({super.key});

  @override
  State<Trainingscreen> createState() => TrainingscreenState();
}

class TrainingscreenState extends State<Trainingscreen> {
  int _selectedFilter = 0;
  int _expandedLessonIndex = 2;
  late final List<_TrainingLesson> _lessons = [
    _TrainingLesson(
      title: "Introduction Video",
      videoSource: "assets/video/introductionvideo.mp4",
      completed: true,
      bookmarked: false,
    ),
    _TrainingLesson(
      title: "Pyung Ahn",
      videoSource: "assets/video/videooftheweek.mp4",
      completed: true,
      bookmarked: true,
    ),
    _TrainingLesson(
      title: "Positive Mindset",
      videoSource: "assets/video/videooftheweek.mp4",
      completed: false,
      bookmarked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     Icon(Icons.arrow_back, size: 18.sp),
              //     const Spacer(),
              //     styledText("Training", TextType.font14500),
              //     const Spacer(),
              //     Container(
              //       width: 26.w,
              //       height: 26.w,
              //       decoration: const BoxDecoration(
              //         color: AppColors.buttoncolour,
              //         shape: BoxShape.circle,
              //       ),
              //       child: Icon(
              //         Icons.notifications,
              //         size: 15.sp,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ],
              // ),
              14.verticalSpace,
              styledText("Level 1 Training", TextType.font20700),
              10.verticalSpace,
              _filterTabs(),
              10.verticalSpace,
              _buildFilteredLessonList(),
              12.verticalSpace,
              Row(
                children: [
                  styledText(
                    "Current Level 1",
                    TextType.font12400,
                    color: const Color(0xFF9B9B9B),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.sports_martial_arts,
                    size: 18.sp,
                    color: const Color(0xFFB3B3B3),
                  ),
                ],
              ),
              4.verticalSpace,
              styledText("Beginner to Red Belt", TextType.font16600),
              8.verticalSpace,
              Row(
                children: [
                  styledText(
                    "Lessons completed",
                    TextType.font12400,
                    color: const Color(0xFF9B9B9B),
                  ),
                  const Spacer(),
                  styledText(
                    "${_lessons.where((e) => e.completed).length}/52",
                    TextType.font16500,
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                children: [
                  styledText("Belt Progression", TextType.font14500),
                  const Spacer(),
                  styledText("20%", TextType.font14500),
                ],
              ),
              6.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: const LinearProgressIndicator(
                  value: 0.2,
                  minHeight: 6,
                  backgroundColor: Color(0xFFD9D9D9),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
                ),
              ),
              8.verticalSpace,
              styledText(
                "You're 33% closer to your next belt!",
                TextType.font12400,
                color: const Color(0xFF9B9B9B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterTabs() {
    final tabs = ["All", "Completed", "Bookmarked"];
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = _selectedFilter == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = index;
                  if (_expandedLessonIndex != -1 &&
                      !_isLessonVisible(_expandedLessonIndex)) {
                    _expandedLessonIndex = -1;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 9.h),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFFD7E5EA) : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: styledText(
                    tabs[index],
                    TextType.font16500,
                    color:
                        isSelected
                            ? AppColors.buttoncolour
                            : const Color(0xFFABABAB),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFilteredLessonList() {
    final visibleIndexes = <int>[];
    for (var i = 0; i < _lessons.length; i++) {
      if (_selectedFilter == 1 && !_lessons[i].completed) continue;
      if (_selectedFilter == 2 && !_lessons[i].bookmarked) continue;
      visibleIndexes.add(i);
    }

    if (visibleIndexes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        alignment: Alignment.center,
        child: styledText(
          _selectedFilter == 2
              ? "No bookmarked lessons yet"
              : "No completed lessons yet",
          TextType.font14500,
          color: const Color(0xFF9B9B9B),
        ),
      );
    }

    return Column(
      children: List.generate(visibleIndexes.length, (listIdx) {
        final lessonIndex = visibleIndexes[listIdx];
        final lesson = _lessons[lessonIndex];
        final expanded = _expandedLessonIndex == lessonIndex;
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: _lessonRow(
            lessonIndex: lessonIndex,
            title: lesson.title,
            completed: lesson.completed,
            showBookmark: lesson.bookmarked,
            expanded: expanded,
            videoSource: lesson.videoSource,
          ),
        );
      }),
    );
  }

  bool _isLessonVisible(int index) {
    if (index < 0 || index >= _lessons.length) return false;
    if (_selectedFilter == 1) return _lessons[index].completed;
    if (_selectedFilter == 2) return _lessons[index].bookmarked;
    return true;
  }

  Widget _lessonRow({
    required int lessonIndex,
    required String title,
    required bool completed,
    required bool showBookmark,
    required bool expanded,
    required String videoSource,
  }) {
    if (!expanded) {
      return GestureDetector(
        onTap: () {
          setState(() {
            _expandedLessonIndex = lessonIndex;
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              if (showBookmark) ...[
                Icon(
                  Icons.bookmark,
                  size: 15.sp,
                  color: const Color(0xFF1F4F9A),
                ),
                6.horizontalSpace,
              ],
              Expanded(child: styledText(title, TextType.font14500)),
              _statusCircle(completed: completed),
            ],
          ),
        ),
      );
    }

    return Container(
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
              styledText(title, TextType.font14500, color: Colors.white),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _lessons[lessonIndex].bookmarked =
                        !_lessons[lessonIndex].bookmarked;
                    if (_selectedFilter == 2 &&
                        !_lessons[lessonIndex].bookmarked) {
                      _expandedLessonIndex = -1;
                    }
                  });
                },
                child: Icon(
                  showBookmark ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
          6.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CustomVideoPlayer(
              videoSource: videoSource,
              isAsset: true,
              height: 120.h,
              width: double.infinity,
              autoPlay: false,
              looping: false,
              showControls: true,
              allowFullScreen: true,
              fit: BoxFit.cover,
            ),
          ),
          8.verticalSpace,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
              color: const Color(0xFF3CB471),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _lessons[lessonIndex].completed = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  styledText(
                    "Mark as Complete",
                    TextType.font12400,
                    color: Colors.white,
                  ),
                  6.horizontalSpace,
                  Icon(
                    _lessons[lessonIndex].completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCircle({required bool completed}) {
    return Container(
      width: 18.w,
      height: 18.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? const Color(0xFF3CB471) : Colors.transparent,
        border: Border.all(
          color: completed ? const Color(0xFF3CB471) : const Color(0xFFD9D9D9),
        ),
      ),
      child:
          completed
              ? Icon(Icons.check, size: 12.sp, color: Colors.white)
              : null,
    );
  }
}

class _TrainingLesson {
  final String title;
  final String videoSource;
  bool completed;
  bool bookmarked;

  _TrainingLesson({
    required this.title,
    required this.videoSource,
    this.completed = false,
    this.bookmarked = false,
  });
}
