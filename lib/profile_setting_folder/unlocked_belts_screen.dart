import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

enum _LessonUiStatus { completed, available, locked }

class _LessonRowData {
  final int number;
  final String title;
  final _LessonUiStatus status;

  const _LessonRowData({
    required this.number,
    required this.title,
    required this.status,
  });
}

/// Lessons for Current Level 1 — matches profile → Unlocked Belts design.
class UnlockedBeltsScreen extends StatelessWidget {
  const UnlockedBeltsScreen({super.key});

  static const String _lorem =
      "consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
  static const String _thumbAsset = "assets/images/splashscreen.png";

  static const List<_LessonRowData> _rows = [
    _LessonRowData(
      number: 1,
      title: "Introduction Video",
      status: _LessonUiStatus.completed,
    ),
    _LessonRowData(
      number: 2,
      title: "Pyung Ahn",
      status: _LessonUiStatus.available,
    ),
    _LessonRowData(
      number: 3,
      title: "Positive Mindset",
      status: _LessonUiStatus.available,
    ),
    _LessonRowData(
      number: 4,
      title: "Chop Techniques",
      status: _LessonUiStatus.locked,
    ),
    _LessonRowData(
      number: 5,
      title: "Goal Setting",
      status: _LessonUiStatus.locked,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundcolour,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => Get.back(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SvgPicture.asset(SvgIcons.backicon, fit: BoxFit.scaleDown),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Center(
              child: GestureDetector(
                onTap: () {},
                child: styledText(
                  "Settings",
                  TextType.font14500,
                  color: const Color(0xFF6E6E6E),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledText(
                "Current Level 1",
                TextType.font20700,
                color: AppColors.appbarTitleColor,
              ),
              14.verticalSpace,
              Row(
                children: [
                  styledText(
                    "Progression",
                    TextType.font14500,
                    fontWeight: FontWeight.w700,
                  ),
                  const Spacer(),
                  styledText(
                    "20%",
                    TextType.font14500,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
              8.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: const LinearProgressIndicator(
                  value: 0.2,
                  minHeight: 6,
                  backgroundColor: Color(0xFFD9D9D9),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
                ),
              ),
              18.verticalSpace,
              ..._rows.map((row) {
                final locked = row.status == _LessonUiStatus.locked;
                VoidCallback? openLevelOne;
                if (!locked && row.number == 1) {
                  openLevelOne = () => Get.to(
                    () => const LevelOneScreen(
                      beltId: 1,
                      beltTitle: 'Video Of The Week',
                    ),
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _LessonCard(
                    data: row,
                    lorem: _lorem,
                    thumbAsset: _thumbAsset,
                    onTap: openLevelOne,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  const _LessonCard({
    required this.data,
    required this.lorem,
    required this.thumbAsset,
    this.onTap,
  });

  final _LessonRowData data;
  final String lorem;
  final String thumbAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locked = data.status == _LessonUiStatus.locked;
    final completed = data.status == _LessonUiStatus.completed;

    final cardBg =
        locked ? const Color(0xFFEDEDED) : Colors.white;
    final titleColor =
        locked ? const Color(0xFF757575) : const Color(0xFF333333);
    final descColor =
        locked ? const Color(0xFF9E9E9E) : const Color(0xFF8A8A8A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: locked
                  ? const Color(0xFFE0E0E0)
                  : const Color(0xFFE8E8E8),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Thumbnail(
                  asset: thumbAsset,
                  locked: locked,
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      styledText(
                        "${data.number}. ${data.title}",
                        TextType.minifont16600hard,
                        color: titleColor,
                      ),
                      4.verticalSpace,
                      styledText(
                        lorem,
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
                  child: _StatusIcon(
                    completed: completed,
                    locked: locked,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.asset,
    required this.locked,
  });

  final String asset;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final thumbWidth = 108.w;
    final thumbHeight = thumbWidth * 9 / 16;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        width: thumbWidth,
        height: thumbHeight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: const Color(0xFF5C5C5C),
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white54,
                      size: 32.sp,
                    ),
                  ),
            ),
            if (locked)
              Container(
                color: AppColors.buttoncolour.withValues(alpha: 0.45),
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
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.completed,
    required this.locked,
  });

  final bool completed;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    if (locked) {
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
