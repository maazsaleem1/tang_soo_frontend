import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/training_progress_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class Trainingscreen extends StatefulWidget {
  /// 0 = All, 1 = Completed, 2 = Bookmarked
  final int initialFilter;

  const Trainingscreen({super.key, this.initialFilter = 0});

  @override
  State<Trainingscreen> createState() => TrainingscreenState();
}

class TrainingscreenState extends State<Trainingscreen> {
  static const Color _selectedTabBg = Color(0x1401708A);
  static const Color _inactiveTabBg = Color(0xFFECECEC);
  static const Color _inactiveTabText = Color(0xFFBDBDBD);

  late int _selectedFilter;

  late final List<_TrainingLesson> _lessons = [
    _TrainingLesson(
      title: "Introduction Video",
      completed: true,
      bookmarked: false,
    ),
    _TrainingLesson(title: "Pyung Ahn", completed: true, bookmarked: true),
    _TrainingLesson(
      title: "Positive Mindset",
      completed: false,
      bookmarked: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _hydrateFromProgress();
  }

  void _hydrateFromProgress() {
    if (!Get.isRegistered<TrainingProgressController>()) return;
    final c = Get.find<TrainingProgressController>();
    for (final l in _lessons) {
      if (c.isTrainingTitleCompleted(l.title)) {
        l.completed = true;
      }
    }
  }

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
              _filterTabs(),
              10.verticalSpace,
              _buildFilteredLessonList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterTabs() {
    final tabs = ["All", "Completed", "Bookmarked"];
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 28.h, color: const Color(0xFFE0E0E0)),
            Expanded(child: _filterTabCell(i, tabs[i])),
          ],
        ],
      ),
    );
  }

  Widget _filterTabCell(int index, String label) {
    final selected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        color: selected ? _selectedTabBg : _inactiveTabBg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Center(
                child: styledText(
                  label,
                  TextType.font16500,
                  color: selected ? AppColors.buttoncolour : _inactiveTabText,
                ),
              ),
            ),
            Container(
              height: 3.h,
              color: selected ? AppColors.buttoncolour : Colors.transparent,
            ),
          ],
        ),
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
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: _lessonCard(
            lessonIndex: lessonIndex,
            title: lesson.title,
            completed: lesson.completed,
            showBookmark: lesson.bookmarked,
          ),
        );
      }),
    );
  }

  Widget _lessonCard({
    required int lessonIndex,
    required String title,
    required bool completed,
    required bool showBookmark,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBookmark) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _lessons[lessonIndex].bookmarked =
                      !_lessons[lessonIndex].bookmarked;
                });
              },
              child: Icon(
                Icons.bookmark_rounded,
                size: 22.sp,
                color: const Color(0xFF1F4F9A),
              ),
            ),
            10.horizontalSpace,
          ],
          Expanded(
            child: styledText(
              title,
              TextType.minifont16600hard,
              color: const Color(0xFF333333),
            ),
          ),
          8.horizontalSpace,
          _completionGlyph(completed: completed),
        ],
      ),
    );
  }

  Widget _completionGlyph({required bool completed}) {
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
    return Row(
      mainAxisSize: MainAxisSize.min,
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

class _TrainingLesson {
  final String title;
  bool completed;
  bool bookmarked;

  _TrainingLesson({
    required this.title,
    this.completed = false,
    this.bookmarked = false,
  });
}
