import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tang_soo_karate/controllers/belt_lessons_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/custom_widgets.dart/video_of_week_embed.dart';
import 'package:tang_soo_karate/models/belt_lessons_model.dart';
import 'package:tang_soo_karate/models/video_of_week_model.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/services/api/api_toast.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

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

/// Belt lesson list + detail. Uses [BeltLessonsController] (GetX); register with [Get.put] before use.
class BeltLessonsScreen extends StatefulWidget {
  const BeltLessonsScreen({
    super.key,
    required this.beltId,
    required this.beltTitle,
  });

  final int beltId;
  final String beltTitle;

  @override
  State<BeltLessonsScreen> createState() => _BeltLessonsScreenState();
}

class _BeltLessonsScreenState extends State<BeltLessonsScreen> {
  late final BeltLessonsController c;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    c = Get.put(
      BeltLessonsController(
        beltId: widget.beltId,
        initialBeltTitle: widget.beltTitle,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (Get.isRegistered<BeltLessonsController>()) {
      Get.delete<BeltLessonsController>();
    }
    super.dispose();
  }

  void _onBack() {
    if (c.selectedLessonId.value != null) {
      c.closeDetail();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: Obx(() {
          final detailId = c.selectedLessonId.value;
          if (detailId != null) {
            return _BeltLessonDetailView(
              controller: c,
              lessonId: detailId,
              onBack: _onBack,
            );
          }
          return _BeltLessonListView(
            controller: c,
            searchController: _searchController,
            onBack: _onBack,
          );
        }),
      ),
    );
  }
}

class _BeltLessonListView extends StatelessWidget {
  const _BeltLessonListView({
    required this.controller,
    required this.searchController,
    required this.onBack,
  });

  final BeltLessonsController controller;
  final TextEditingController searchController;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
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
                onPressed: onBack,
                icon: SvgPicture.asset(SvgIcons.backicon),
              ),
            ],
          ),
          6.verticalSpace,
          AppInput(
            placeHolder: 'Search by lesson',
            controller: searchController,
            onChanged: controller.setSearch,
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
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const _BeltLessonsListShimmer();
              }
              if (controller.errorMessage.value != null) {
                return _LoadError(
                  message: controller.errorMessage.value ?? '',
                  onRetry: controller.retry,
                );
              }
              final beltTitle = controller.beltName.value;
              // Obx dependency: search + completion toggles + title
              <Object?>[
                controller.searchQuery.value,
                controller.completedRev.value,
                beltTitle,
              ];
              final list = controller.filteredLessons;
              if (list.isEmpty) {
                return Center(
                  child: styledText(
                    'No lessons match your search.',
                    TextType.font14500,
                    color: const Color(0xFF9B9B9B),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styledText(beltTitle, TextType.font20700),
                  12.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final lesson = list[index];
                        final n = index + 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _LessonListCard(
                            controller: controller,
                            lesson: lesson,
                            displayNumber: n,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

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
            styledText(
              'Something went wrong',
              TextType.font16600,
              color: const Color(0xFF333333),
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF6E6E6E),
              ),
              textAlign: TextAlign.center,
            ),
            16.verticalSpace,
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _BeltLessonsListShimmer extends StatelessWidget {
  const _BeltLessonsListShimmer();

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
            width: 0.5.sw,
            height: 22.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          14.verticalSpace,
          ...List.generate(
            7,
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
        ],
      ),
    );
  }
}

class _LessonListCard extends StatelessWidget {
  const _LessonListCard({
    required this.controller,
    required this.lesson,
    required this.displayNumber,
  });

  final BeltLessonsController controller;
  final BeltLesson lesson;
  final int displayNumber;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = controller.completedRev.value;
      final unlocked = !lesson.isLocked;
      final completed = controller.isCompleted(lesson);
      final locked = lesson.isLocked;

      final cardBg = locked ? const Color(0xFFEDEDED) : Colors.white;
      final titleColor =
          locked ? const Color(0xFF757575) : const Color(0xFF333333);
      final descColor = const Color(0xFF8A8A8A);
      final desc = _stripHtml(lesson.shortDescription ?? lesson.content);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: unlocked ? () => controller.openLesson(lesson) : null,
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
                  _LessonThumb(
                    locked: locked,
                    durationLabel: _formatDurationSeconds(lesson.durationSeconds),
                    imageUrl: lesson.thumbnailUrl,
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
                    child: _StatusTrailing(
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
    });
  }
}

class _LessonThumb extends StatelessWidget {
  const _LessonThumb({
    required this.locked,
    required this.durationLabel,
    this.imageUrl,
  });

  final bool locked;
  final String durationLabel;
  final String? imageUrl;

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
            _thumbBackground(
              width: thumbWidth,
              height: thumbHeight,
              url: url,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: thumbHeight * 0.45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.55),
                    ],
                  ),
                ),
              ),
            ),
            if (locked)
              Container(color: Colors.black.withValues(alpha: 0.38)),
            if (url == null || url.isEmpty)
              Center(
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.white54,
                  size: 32.sp,
                ),
              )
            else
              Center(
                child: Icon(
                  Icons.play_circle_filled_rounded,
                  color: Colors.white.withValues(alpha: locked ? 0.4 : 0.92),
                  size: 34.sp,
                  shadows: const [
                    Shadow(blurRadius: 8, color: Colors.black54),
                  ],
                ),
              ),
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

  Widget _thumbBackground({
    required double width,
    required double height,
    required String? url,
  }) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        gaplessPlayback: true,
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
        errorBuilder: (_, __, ___) => _placeholderLayer(),
      );
    }
    return _placeholderLayer();
  }

  Widget _placeholderLayer() {
    return const ColoredBox(color: _placeholderBg);
  }
}

class _StatusTrailing extends StatelessWidget {
  const _StatusTrailing({
    required this.completed,
    required this.unlocked,
  });

  final bool completed;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
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

class _BeltLessonDetailView extends StatelessWidget {
  const _BeltLessonDetailView({
    required this.controller,
    required this.lessonId,
    required this.onBack,
  });

  final BeltLessonsController controller;
  final int lessonId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      <Object?>[
        controller.bookmarkRev.value,
        controller.completedRev.value,
        controller.isSubmittingComplete.value,
        controller.isSubmittingBookmark.value,
      ];
      final lesson = controller.lessonById(lessonId);
      if (lesson == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => onBack());
        return const SizedBox.shrink();
      }

      final done = controller.isCompleted(lesson);
      final submitting = controller.isSubmittingComplete.value;
      final bookmarkSubmitting = controller.isSubmittingBookmark.value;
      final marked = controller.isBookmarked(lesson);
      final videoUrl = lesson.firstVideoUrl ?? '';
      final desc = _stripHtml(lesson.shortDescription ?? lesson.content);
      final ordered = controller.lessons.toList();
      final idx = ordered.indexWhere((x) => x.id == lesson.id);
      final nextLessons =
          idx >= 0 && idx < ordered.length - 1
              ? ordered.sublist(idx + 1)
              : <BeltLesson>[];

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
                  onPressed: onBack,
                  icon: SvgPicture.asset(SvgIcons.backicon),
                ),
              ],
            ),
            8.verticalSpace,
            Obx(
              () => styledText(controller.beltName.value, TextType.font20700),
            ),
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
                          SizedBox(
                            height: 200.h,
                            width: 1.sw,
                            child:
                                videoUrl.isEmpty
                                    ? ColoredBox(
                                      color: const Color(0xFF2A2A2A),
                                      child: Center(
                                        child: Icon(
                                          Icons.ondemand_video_rounded,
                                          color: Colors.white54,
                                          size: 48.sp,
                                        ),
                                      ),
                                    )
                                    : VideoOfWeekModel.isYoutubeUrl(videoUrl)
                                    ? VideoOfWeekEmbed(
                                      key: ValueKey(videoUrl),
                                      videoUrl: videoUrl,
                                      height: 200.h,
                                      width: 1.sw,
                                    )
                                    : CustomVideoPlayer(
                                      key: ValueKey(videoUrl),
                                      videoSource: videoUrl,
                                      isAsset: false,
                                      height: 200.h,
                                      width: 1.sw,
                                      autoPlay: true,
                                      looping: true,
                                      showControls: true,
                                      allowFullScreen: true,
                                      fit: BoxFit.cover,
                                      contentDurationHint: Duration(
                                        seconds: lesson.durationSeconds,
                                      ),
                                    ),
                          ),
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: Material(
                              color: Colors.black.withValues(alpha: 0.45),
                              shape: const CircleBorder(),
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap:
                                    bookmarkSubmitting
                                        ? null
                                        : () async {
                                          if (marked) {
                                            Get.offAll(
                                              () => const NavBarScreen(
                                                initialIndex: 2,
                                                initialTrainingFilter: 2,
                                              ),
                                            );
                                            return;
                                          }
                                          final ok =
                                              await controller.submitBookmark(
                                                lesson,
                                                context,
                                              );
                                          if (!context.mounted) return;
                                          if (ok) {
                                            Get.offAll(
                                              () => const NavBarScreen(
                                                initialIndex: 2,
                                                initialTrainingFilter: 2,
                                              ),
                                            );
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              AppSuccessToast(
                                                title:
                                                    'You have bookmarked successfully.',
                                              ).showToast(Get.context);
                                            });
                                          }
                                        },
                                child: Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child:
                                      bookmarkSubmitting && !marked
                                      ? SizedBox(
                                          width: 20.sp,
                                          height: 20.sp,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Icon(
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
                      lesson.title,
                      TextType.font16600,
                      color: const Color(0xFF222222),
                      fontWeight: FontWeight.w700,
                    ),
                    6.verticalSpace,
                    styledText(
                      desc.isEmpty ? ' ' : desc,
                      TextType.font14400,
                      color: const Color(0xFF6E6E6E),
                    ),
                    14.verticalSpace,
                    GestureDetector(
                      onTap:
                          done || submitting
                              ? null
                              : () async {
                                final ok = await controller.markComplete(
                                  lesson,
                                  context,
                                );
                                if (!context.mounted) return;
                                if (ok) {
                                  Get.offAll(
                                    () => const NavBarScreen(
                                      initialIndex: 2,
                                      initialTrainingFilter: 1,
                                    ),
                                  );
                                }
                              },
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
                                submitting
                                    ? 'Saving...'
                                    : (done ? 'Completed' : 'Mark as Complete'),
                                TextType.font15500,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            if (submitting)
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            else
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
            if (nextLessons.isNotEmpty) ...[
              18.verticalSpace,
              Text(
                'Next Lessons:',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF333333),
                ),
              ),
              10.verticalSpace,
              ...nextLessons.map(
                (l) => _NextLessonRow(controller: controller, lesson: l),
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _NextLessonRow extends StatelessWidget {
  const _NextLessonRow({
    required this.controller,
    required this.lesson,
  });

  final BeltLessonsController controller;
  final BeltLesson lesson;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final _ = controller.completedRev.value;
      final unlocked = !lesson.isLocked;
      final completed = controller.isCompleted(lesson);
      final locked = lesson.isLocked;
      final cardBg = locked ? const Color(0xFFEDEDED) : Colors.white;
      final titleColor =
          locked ? const Color(0xFF757575) : const Color(0xFF333333);
      final desc = _stripHtml(lesson.shortDescription ?? lesson.content);
      final i = controller.lessons.indexWhere((x) => x.id == lesson.id);
      final n = i >= 0 ? i + 1 : 1;

      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                unlocked
                    ? () => controller.openLesson(lesson)
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
                    _LessonThumb(
                      locked: locked,
                      durationLabel: _formatDurationSeconds(
                        lesson.durationSeconds,
                      ),
                      imageUrl: lesson.thumbnailUrl,
                    ),
                    10.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styledText(
                            '$n. ${lesson.title}',
                            TextType.minifont16600hard,
                            color: titleColor,
                          ),
                          4.verticalSpace,
                          styledText(
                            desc.isEmpty ? ' ' : desc,
                            TextType.font12400,
                            color:
                                locked
                                    ? const Color(0xFF8A8A8A)
                                    : const Color(0xFF8A8A8A),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _StatusTrailing(completed: completed, unlocked: unlocked),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
