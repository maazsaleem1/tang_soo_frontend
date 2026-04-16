import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tang_soo_karate/controllers/training_lessons_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/models/user_training_lesson_model.dart';
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

  @override
  void initState() {
    super.initState();
    Get.put(
      TrainingLessonsController(initialTabIndex: widget.initialFilter),
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<TrainingLessonsController>()) {
      Get.delete<TrainingLessonsController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<TrainingLessonsController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterTabs(ctrl),
              10.verticalSpace,
              Expanded(child: _TrainingListBody(controller: ctrl)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterTabs(TrainingLessonsController ctrl) {
    const tabs = ['All', 'Completed', 'Bookmarked'];
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Obx(() {
        final selected = ctrl.selectedTab.value;
        return Row(
          children: [
            for (var i = 0; i < tabs.length; i++) ...[
              if (i > 0)
                Container(
                  width: 1,
                  height: 28.h,
                  color: const Color(0xFFE0E0E0),
                ),
              Expanded(child: _filterTabCell(ctrl, i, tabs[i], selected == i)),
            ],
          ],
        );
      }),
    );
  }

  Widget _filterTabCell(
    TrainingLessonsController ctrl,
    int index,
    String label,
    bool selected,
  ) {
    return GestureDetector(
      onTap: () => ctrl.selectTab(index),
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
}

class _TrainingListBody extends StatelessWidget {
  const _TrainingListBody({required this.controller});

  final TrainingLessonsController controller;

  String _emptyMessage(int tab) {
    switch (tab) {
      case 1:
        return 'No completed lessons yet';
      case 2:
        return 'No bookmarked lessons yet';
      default:
        return 'No lessons yet';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      <Object?>[
        controller.selectedTab.value,
        controller.lessons.length,
        controller.isLoading.value,
        controller.isLoadingMore.value,
        controller.errorMessage.value,
        controller.hasNextPage.value,
      ];
      if (controller.isLoading.value && controller.lessons.isEmpty) {
        return const _TrainingListShimmer();
      }
      if (controller.errorMessage.value != null &&
          controller.lessons.isEmpty) {
        return _TrainingErrorBlock(
          message: controller.errorMessage.value ?? '',
          onRetry: controller.retry,
        );
      }
      if (controller.lessons.isEmpty) {
        return Center(
          child: styledText(
            _emptyMessage(controller.selectedTab.value),
            TextType.font14500,
            color: const Color(0xFF9B9B9B),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount:
            controller.lessons.length +
            (controller.hasNextPage.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= controller.lessons.length) {
            return Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 12.h),
              child: Center(
                child: controller.isLoadingMore.value
                    ? SizedBox(
                        width: 28.w,
                        height: 28.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : TextButton(
                        onPressed: controller.loadMore,
                        child: styledText(
                          'Load more',
                          TextType.font14500,
                          color: AppColors.buttoncolour,
                        ),
                      ),
              ),
            );
          }
          final lesson = controller.lessons[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _TrainingLessonCard(
              lesson: lesson,
              isBookmarkedTab: controller.selectedTab.value == 2,
            ),
          );
        },
      );
    });
  }
}

class _TrainingLessonCard extends StatelessWidget {
  const _TrainingLessonCard({
    required this.lesson,
    this.isBookmarkedTab = false,
  });

  final UserTrainingLesson lesson;
  /// Bookmarked filter tab: show bookmark on the right, not completion state.
  final bool isBookmarkedTab;

  static const Color _bookmarkBlue = Color(0xFF1F4F9A);

  @override
  Widget build(BuildContext context) {
    final locked = lesson.isLocked;
    final titleColor =
        locked ? const Color(0xFF757575) : const Color(0xFF333333);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            locked
                ? null
                : () {
                  Get.to(
                    () => LevelOneScreen(
                      beltId: lesson.navigationBeltId,
                      beltTitle: lesson.title,
                    ),
                  );
                },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
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
              if (!isBookmarkedTab && lesson.isBookmarked) ...[
                Icon(
                  Icons.bookmark_rounded,
                  size: 22.sp,
                  color: _bookmarkBlue,
                ),
                10.horizontalSpace,
              ],
              Expanded(
                child: styledText(
                  lesson.title,
                  TextType.minifont16600hard,
                  color: titleColor,
                ),
              ),
              8.horizontalSpace,
              if (isBookmarkedTab)
                SizedBox(
                  width: 28.w,
                  height: 28.w,
                  child: Icon(
                    Icons.bookmark_rounded,
                    color: _bookmarkBlue,
                    size: 26.sp,
                  ),
                )
              else
                _completionGlyph(completed: lesson.isCompleted),
            ],
          ),
        ),
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

class _TrainingListShimmer extends StatelessWidget {
  const _TrainingListShimmer();

  static const _base = Color(0xFFE6E6E6);
  static const _highlight = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 1300),
      child: ListView(
        padding: EdgeInsets.zero,
        children: List.generate(
          6,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrainingErrorBlock extends StatelessWidget {
  const _TrainingErrorBlock({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message.replaceFirst('Exception: ', ''),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6E6E6E)),
            ),
            16.verticalSpace,
            TextButton(
              onPressed: onRetry,
              child: styledText(
                'Retry',
                TextType.font14500,
                color: AppColors.buttoncolour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
