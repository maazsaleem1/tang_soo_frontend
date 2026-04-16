import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tang_soo_karate/controllers/progress_next_lessons_controller.dart';
import 'package:tang_soo_karate/controllers/progress_overview_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/models/progress_next_lesson_model.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

String _stripHtml(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  return raw.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}

String _formatDurationSeconds(int s) {
  if (s <= 0) return '--:--';
  final m = s ~/ 60;
  final sec = s % 60;
  return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
}

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(ProgressOverviewController());
    Get.put(ProgressNextLessonsController());
  }

  @override
  void dispose() {
    if (Get.isRegistered<ProgressOverviewController>()) {
      Get.delete<ProgressOverviewController>();
    }
    if (Get.isRegistered<ProgressNextLessonsController>()) {
      Get.delete<ProgressNextLessonsController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overviewCtrl = Get.find<ProgressOverviewController>();
    final nextCtrl = Get.find<ProgressNextLessonsController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                <Object?>[
                  overviewCtrl.overview.value,
                  overviewCtrl.isLoading.value,
                  overviewCtrl.errorMessage.value,
                ];
                if (overviewCtrl.isLoading.value) {
                  return const _OverviewBlockShimmer();
                }
                if (overviewCtrl.errorMessage.value != null) {
                  return _OverviewErrorBlock(
                    message: overviewCtrl.errorMessage.value ?? '',
                    onRetry: overviewCtrl.retry,
                  );
                }
                return _OverviewBlock(overviewCtrl: overviewCtrl);
              }),
              22.verticalSpace,
              styledText('Next Lesson', TextType.font20700),
              12.verticalSpace,
              Obx(() {
                <Object?>[
                  overviewCtrl.isLoading.value,
                  overviewCtrl.overview.value,
                  nextCtrl.lessons.length,
                  nextCtrl.isLoading.value,
                  nextCtrl.errorMessage.value,
                  nextCtrl.hasNext.value,
                  nextCtrl.isLoadingMore.value,
                ];
                if (overviewCtrl.isLoading.value) {
                  return const _NextLessonsListShimmer();
                }
                if (nextCtrl.isLoading.value) {
                  return const _NextLessonsListShimmer();
                }
                if (nextCtrl.errorMessage.value != null) {
                  return _NextLessonsErrorBlock(
                    message: nextCtrl.errorMessage.value ?? '',
                    onRetry: nextCtrl.retry,
                  );
                }
                if (nextCtrl.lessons.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: styledText(
                      'No upcoming lessons.',
                      TextType.font14500,
                      color: const Color(0xFF9B9B9B),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...nextCtrl.lessons.asMap().entries.map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: _NextLessonApiCard(
                          displayNumber: e.key + 1,
                          lesson: e.value,
                        ),
                      ),
                    ),
                    if (nextCtrl.hasNext.value)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
                        child: Center(
                          child:
                              nextCtrl.isLoadingMore.value
                                  ? SizedBox(
                                    width: 24.w,
                                    height: 24.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : TextButton(
                                    onPressed: nextCtrl.loadMore,
                                    child: styledText(
                                      'Load more',
                                      TextType.font14500,
                                      color: AppColors.buttoncolour,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewBlockShimmer extends StatelessWidget {
  const _OverviewBlockShimmer();

  static const _base = Color(0xFFE6E6E6);
  static const _highlight = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 1300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 14.h,
            width: 0.45.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          10.verticalSpace,
          Container(
            height: 20.h,
            width: 0.85.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          14.verticalSpace,
          Container(
            height: 12.h,
            width: 1.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          10.verticalSpace,
          Container(
            height: 8.h,
            width: 1.sw,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextLessonsListShimmer extends StatelessWidget {
  const _NextLessonsListShimmer();

  static const _base = Color(0xFFE6E6E6);
  static const _highlight = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 1300),
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              height: 88.h,
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

class _OverviewErrorBlock extends StatelessWidget {
  const _OverviewErrorBlock({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        styledText(
          'Overall progress',
          TextType.font16600,
          color: const Color(0xFF333333),
        ),
        8.verticalSpace,
        Text(
          message,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6E6E6E)),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

class _NextLessonsErrorBlock extends StatelessWidget {
  const _NextLessonsErrorBlock({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF6E6E6E)),
        ),
        TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

class _OverviewBlock extends StatelessWidget {
  const _OverviewBlock({required this.overviewCtrl});

  final ProgressOverviewController overviewCtrl;

  @override
  Widget build(BuildContext context) {
    final pctLabel = overviewCtrl.percentLabel;
    final frac = overviewCtrl.progressFraction;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        styledText(
          overviewCtrl.currentLevelDisplay,
          TextType.font12400,
          color: const Color(0xFF9B9B9B),
        ),
        8.verticalSpace,
        styledText(
          overviewCtrl.currentLessonTitleLine,
          TextType.font16600,
          color: const Color(0xFF333333),
          fontWeight: FontWeight.w700,
        ),
        14.verticalSpace,
        Row(
          children: [
            styledText(
              'Lessons Completed',
              TextType.font12400,
              color: const Color(0xFF9B9B9B),
            ),
            const Spacer(),
            styledText(
              '${overviewCtrl.completedCount}/${overviewCtrl.totalCount}',
              TextType.font16500,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            styledText(
              'Progression',
              TextType.font14500,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            styledText(
              '$pctLabel%',
              TextType.font14500,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        6.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: LinearProgressIndicator(
            value: frac.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: const Color(0xFFD9D9D9),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
          ),
        ),
        8.verticalSpace,
        styledText(
          "You're $pctLabel% closer to your next level!",
          TextType.font12400,
          color: const Color(0xFF9B9B9B),
        ),
      ],
    );
  }
}

class _NextLessonApiCard extends StatelessWidget {
  const _NextLessonApiCard({required this.displayNumber, required this.lesson});

  final int displayNumber;
  final ProgressNextLesson lesson;

  @override
  Widget build(BuildContext context) {
    final locked = !lesson.isUnlocked;
    final desc = _stripHtml(lesson.shortDescription ?? lesson.content ?? '');
    final titleColor =
        locked ? const Color(0xFF757575) : const Color(0xFF333333);
    final descColor = const Color(0xFF8A8A8A);
    final thumbUrl = lesson.thumbnailUrl;

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
                _LessonThumbNetwork(
                  imageUrl: thumbUrl,
                  locked: locked,
                  durationLabel: _formatDurationSeconds(lesson.durationSeconds),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      styledText(
                        '$displayNumber. ${lesson.title}',
                        TextType.minifont16600hard,
                        color: titleColor,
                      ),
                      4.verticalSpace,
                      styledText(
                        desc.isEmpty ? ' ' : desc,
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
                          : _TealContinueGlyph(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonThumbNetwork extends StatelessWidget {
  const _LessonThumbNetwork({
    required this.imageUrl,
    required this.locked,
    required this.durationLabel,
  });

  final String? imageUrl;
  final bool locked;
  final String durationLabel;

  static const Color _placeholderBg = Color(0xFF5C5C5C);

  @override
  Widget build(BuildContext context) {
    final thumbWidth = 108.w;
    final thumbHeight = thumbWidth * 9 / 16;
    final url = imageUrl?.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: thumbWidth,
        height: thumbHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null && url.isNotEmpty)
              Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return ColoredBox(
                    color: const Color(0xFFE8E8E8),
                    child: Center(
                      child: SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.buttoncolour,
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder:
                    (_, __, ___) => const ColoredBox(
                      color: _placeholderBg,
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.white54,
                        ),
                      ),
                    ),
              )
            else
              const ColoredBox(
                color: _placeholderBg,
                child: Center(
                  child: Icon(Icons.play_circle_outline, color: Colors.white54),
                ),
              ),
            if (locked) Container(color: Colors.black.withValues(alpha: 0.42)),
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
                  durationLabel,
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
}

class _TealContinueGlyph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
