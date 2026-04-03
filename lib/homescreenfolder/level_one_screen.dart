import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/training_progress_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
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

class _LessonData {
  final int number;
  final String title;
  final String videoAsset;
  final String duration;

  const _LessonData({
    required this.number,
    required this.title,
    required this.videoAsset,
    required this.duration,
  });
}

class _LevelOneContent extends StatefulWidget {
  const _LevelOneContent();

  @override
  State<_LevelOneContent> createState() => _LevelOneContentState();
}

class _LevelOneContentState extends State<_LevelOneContent> {
  static const int _freeTrialLessonCount = 3;
  static const String _lorem =
      "consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
  static const String _thumbAsset = "assets/images/splashscreen.png";

  static const List<_LessonData> _lessons = [
    _LessonData(
      number: 1,
      title: "Introduction Video",
      videoAsset: "assets/video/introductionvideo.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 2,
      title: "Lesson of the Week: Pyung Ahn",
      videoAsset: "assets/video/videooftheweek.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 3,
      title: "Positive Mindset",
      videoAsset: "assets/video/videooftheweek.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 4,
      title: "Chop Techniques",
      videoAsset: "assets/video/introductionvideo.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 5,
      title: "Goal Setting",
      videoAsset: "assets/video/videooftheweek.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 6,
      title: "Traditional Breathing Exercises",
      videoAsset: "assets/video/introductionvideo.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 7,
      title: "Punch Techniques",
      videoAsset: "assets/video/videooftheweek.mp4",
      duration: "08:02",
    ),
    _LessonData(
      number: 8,
      title: "Situational Awareness",
      videoAsset: "assets/video/introductionvideo.mp4",
      duration: "08:02",
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  int? _detailLessonIndex;
  final Set<int> _completedLessons = {};
  final Set<int> _bookmarkedLessons = {};

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<TrainingProgressController>()) {
      _completedLessons.addAll(
        Get.find<TrainingProgressController>().levelOneCompletedIndices,
      );
    }
  }

  static String _trainingTitleForLevelIndex(int index) {
    const titles = <int, String>{
      0: "Introduction Video",
      1: "Pyung Ahn",
      2: "Positive Mindset",
      3: "Chop Techniques",
      4: "Goal Setting",
      5: "Traditional Breathing Exercises",
      6: "Punch Techniques",
      7: "Situational Awareness",
    };
    return titles[index] ?? "";
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isUnlocked(int index) {
    if (index >= _freeTrialLessonCount) return false;
    if (index == 0) return true;
    return _completedLessons.contains(index - 1);
  }

  List<int> get _filteredIndices {
    final q = _searchQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return List<int>.generate(_lessons.length, (i) => i);
    }
    final out = <int>[];
    for (var i = 0; i < _lessons.length; i++) {
      final t = _lessons[i].title.toLowerCase();
      if (t.contains(q)) out.add(i);
    }
    return out;
  }

  void _openDetail(int index) {
    if (!_isUnlocked(index)) return;
    setState(() => _detailLessonIndex = index);
  }

  void _onBack() {
    if (_detailLessonIndex != null) {
      setState(() => _detailLessonIndex = null);
    } else {
      Get.back();
    }
  }

  void _onMarkComplete(int index) {
    TrainingProgressController.ensureRegistered();
    Get.find<TrainingProgressController>().completeLevelOneLesson(
      index,
      _trainingTitleForLevelIndex(index),
    );
    setState(() {
      _completedLessons.add(index);
    });
    Get.offAll(
      () => const NavBarScreen(initialIndex: 2, initialTrainingFilter: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child:
            _detailLessonIndex != null
                ? _buildDetailView(_detailLessonIndex!)
                : _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    final indices = _filteredIndices;

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _onBack(),
                icon: SvgPicture.asset(SvgIcons.backicon),
              ),
            ],
          ),
          6.verticalSpace,
          // _searchField(),
          AppInput(
            placeHolder: "Search by lesson",
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            backColor: AppColors.whiteColor,
            borderColor: const Color(0xFFE0E0E0),
            bottomMargin: 0,
            borderradius: 12,
            enabledborderradius: 12,
            prefixIcon: Icon(
              Icons.search_rounded,
              color: const Color(0xFF9E9E9E),
              size: 22.sp,
            ),
          ),
          14.verticalSpace,
          styledText("Foundations & Intro", TextType.font20700),
          12.verticalSpace,
          Expanded(
            child: ListView.builder(
              itemCount: _listItemCount(indices),
              itemBuilder: (context, position) {
                final mapped = _mapListPositionToEntry(indices, position);
                if (mapped.isPaywall) {
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
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _lessonListCard(mapped.index!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Positions: optional paywall insert, then one widget per filtered index.
  int _listItemCount(List<int> indices) {
    var n = indices.length;
    if (_searchQuery.isEmpty && _hasLockedLesson(indices)) {
      n += 1;
    }
    return n;
  }

  bool _hasLockedLesson(List<int> indices) {
    return indices.any((i) => i >= _freeTrialLessonCount);
  }

  ({bool isPaywall, int? index}) _mapListPositionToEntry(
    List<int> indices,
    int position,
  ) {
    if (_searchQuery.isNotEmpty || !_hasLockedLesson(indices)) {
      return (isPaywall: false, index: indices[position]);
    }
    final firstLockedPos = indices.indexWhere(
      (i) => i >= _freeTrialLessonCount,
    );
    if (firstLockedPos < 0) {
      return (isPaywall: false, index: indices[position]);
    }
    final paywallAt = firstLockedPos;
    if (position < paywallAt) {
      return (isPaywall: false, index: indices[position]);
    }
    if (position == paywallAt) {
      return (isPaywall: true, index: null);
    }
    return (isPaywall: false, index: indices[position - 1]);
  }

  bool _isHeavyBlurLocked(int index) {
    return !_isUnlocked(index) && index == _lessons.length - 1;
  }

  Widget _lessonListCard(int index) {
    final lesson = _lessons[index];
    final unlocked = _isUnlocked(index);
    final completed = _completedLessons.contains(index);
    final locked = !unlocked;
    final heavyBlur = _isHeavyBlurLocked(index);

    final cardBg = locked ? const Color(0xFFEDEDED) : Colors.white;
    final titleColor =
        heavyBlur
            ? const Color(0xFFC8C8C8)
            : locked
            ? const Color(0xFF757575)
            : const Color(0xFF333333);
    final descColor =
        heavyBlur ? const Color(0xFFD0D0D0) : const Color(0xFF8A8A8A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: unlocked ? () => _openDetail(index) : null,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _thumbnail(
                  lesson: lesson,
                  locked: locked,
                  heavyBlur: heavyBlur,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      styledText(
                        "${lesson.number}. ${lesson.title}",
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
                  child: _statusTrailing(
                    completed: completed,
                    unlocked: unlocked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumbnail({
    required _LessonData lesson,
    required bool locked,
    required bool heavyBlur,
  }) {
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
                  lesson.duration,
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

  Widget _statusTrailing({required bool completed, required bool unlocked}) {
    if (!unlocked) {
      return Icon(
        Icons.lock_rounded,
        size: 20.sp,
        color: const Color(0xFFF7A600),
      );
    }
    if (completed) {
      return Container(
        width: 28.w,
        height: 28.w,
        decoration: const BoxDecoration(
          color: Color(0xFF3CB471),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: 16.sp),
      );
    }
    return _tealContinueGlyph();
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

  Widget _buildDetailView(int activeIndex) {
    final lesson = _lessons[activeIndex];
    final done = _completedLessons.contains(activeIndex);
    final marked = _bookmarkedLessons.contains(activeIndex);

    final nextIndices = <int>[];
    for (var i = activeIndex + 1; i < _lessons.length; i++) {
      nextIndices.add(i);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _onBack(),
                icon: SvgPicture.asset(SvgIcons.backicon),
              ),
            ],
          ),
          8.verticalSpace,
          styledText("Foundations & Intro", TextType.font20700),
          14.verticalSpace,
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      children: [
                        CustomVideoPlayer(
                          key: ValueKey<String>(
                            lesson.videoAsset + activeIndex.toString(),
                          ),
                          videoSource: lesson.videoAsset,
                          isAsset: true,
                          height: 200.h,
                          width: 1.sw,
                          autoPlay: true,
                          looping: true,
                          showControls: true,
                          allowFullScreen: true,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Material(
                            color: Colors.black.withValues(alpha: 0.45),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                setState(() {
                                  if (marked) {
                                    _bookmarkedLessons.remove(activeIndex);
                                  } else {
                                    _bookmarkedLessons.add(activeIndex);
                                  }
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Icon(
                                  marked
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                  styledText(
                    "${lesson.number}. ${lesson.title}",
                    TextType.font16600,
                    color: const Color(0xFF222222),
                    fontWeight: FontWeight.w700,
                  ),
                  6.verticalSpace,
                  styledText(
                    _lorem,
                    TextType.font14400,
                    color: const Color(0xFF6E6E6E),
                  ),
                  14.verticalSpace,
                  GestureDetector(
                    onTap: done ? null : () => _onMarkComplete(activeIndex),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 14.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buttoncolour,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: styledText(
                              done ? "Completed" : "Mark as Complete",
                              TextType.font15500,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              color: AppColors.buttoncolour,
                              size: 15.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (nextIndices.isNotEmpty) ...[
            18.verticalSpace,
            Text(
              "Next Lessons:",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
            ),
            10.verticalSpace,
            ...nextIndices.map(_nextLessonRow),
          ],
        ],
      ),
    );
  }

  Widget _nextLessonRow(int index) {
    final lesson = _lessons[index];
    final unlocked = _isUnlocked(index);
    final completed = _completedLessons.contains(index);
    final locked = !unlocked;
    final heavyBlur = _isHeavyBlurLocked(index);

    final cardBg = locked ? const Color(0xFFEDEDED) : Colors.white;
    final titleColor =
        heavyBlur
            ? const Color(0xFFC8C8C8)
            : locked
            ? const Color(0xFF757575)
            : const Color(0xFF333333);

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              unlocked
                  ? () => setState(() => _detailLessonIndex = index)
                  : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Ink(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                children: [
                  _thumbnail(
                    lesson: lesson,
                    locked: locked,
                    heavyBlur: heavyBlur,
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styledText(
                          "${lesson.number}. ${lesson.title}",
                          TextType.minifont16600hard,
                          color: titleColor,
                        ),
                        4.verticalSpace,
                        styledText(
                          _lorem,
                          TextType.font12400,
                          color:
                              heavyBlur
                                  ? const Color(0xFFD0D0D0)
                                  : const Color(0xFF8A8A8A),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _statusTrailing(completed: completed, unlocked: unlocked),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
