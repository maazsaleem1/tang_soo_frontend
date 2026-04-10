import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tang_soo_karate/controllers/home_plan_modules_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/custom_widgets.dart/video_of_week_embed.dart';
import 'package:tang_soo_karate/models/plan_level_preview_model.dart';
import 'package:tang_soo_karate/models/video_of_week_model.dart';
import 'package:tang_soo_karate/services/lessons/lesson_service.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/homescreenfolder/level_three_screen.dart';
import 'package:tang_soo_karate/homescreenfolder/level_two_screen.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/purchase_plan_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LessonService _lessonService = LessonService();

  VideoOfWeekModel? _videoOfWeek;
  bool _videoOfWeekLoading = true;

  static const Color _tealPrimary = Color(0xFF01708A);
  static const Color _selectedTabBg = Color(0x1401708A);
  static const Color _inactiveTabBg = Color(0xFFECECEC);
  static const Color _inactiveTabText = Color(0xFFBDBDBD);
  static const Color _moduleTileBg = Color(0xFF01556A);
  static const Color _lockColor = Color(0xFFF7A600);

  @override
  void initState() {
    super.initState();
    Get.put(HomePlanModulesController());
    _loadVideoOfTheWeek();
  }

  @override
  void dispose() {
    if (Get.isRegistered<HomePlanModulesController>()) {
      Get.delete<HomePlanModulesController>();
    }
    super.dispose();
  }

  Future<void> _loadVideoOfTheWeek() async {
    setState(() => _videoOfWeekLoading = true);
    try {
      final data = await _lessonService.fetchVideoOfTheWeek(context: context);
      if (!mounted) return;
      setState(() => _videoOfWeek = data);
    } catch (e, st) {
      debugPrint('HomeScreen._loadVideoOfTheWeek: $e\n$st');
      if (!mounted) return;
      setState(() => _videoOfWeek = null);
    } finally {
      if (mounted) setState(() => _videoOfWeekLoading = false);
    }
  }

  String get _videoOfWeekSubtitle {
    final title = _videoOfWeek?.lesson.title.trim();
    if (title != null && title.isNotEmpty) {
      return '$title – Lesson of the Week';
    }
    return 'Introduction Video – Lesson of the Week';
  }

  Widget _videoOfWeekPlayer() {
    if (_videoOfWeekLoading) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          height: 130.h,
          width: 1.sw,
          child: ColoredBox(
            color: const Color(0xFFECECEC),
            child: Center(
              child: CircularProgressIndicator(
                color: _tealPrimary,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
      );
    }

    final url = _videoOfWeek?.url.trim() ?? '';
    if (url.isNotEmpty) {
      if (VideoOfWeekModel.isYoutubeUrl(url)) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: VideoOfWeekEmbed(videoUrl: url, height: 200.h, width: 1.sw),
        );
      }
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CustomVideoPlayer(
          videoSource: url,
          isAsset: false,
          height: 130.h,
          width: 1.sw,
          autoPlay: true,
          looping: true,
          showControls: true,
          allowFullScreen: true,
          fit: BoxFit.cover,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: CustomVideoPlayer(
        videoSource: "assets/video/videooftheweek.mp4",
        isAsset: true,
        height: 130.h,
        width: 1.sw,
        autoPlay: true,
        looping: true,
        showControls: true,
        allowFullScreen: true,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Container(
            //       width: 40.w,
            //       height: 40.w,
            //       decoration: const BoxDecoration(shape: BoxShape.circle),
            //       child: ClipOval(
            //         child: SvgPicture.asset(
            //           "assets/images/profile_avatar.svg",
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //     10.horizontalSpace,
            //     styledText("Welcome, John!", TextType.font14500),
            //     const Spacer(),
            //     GestureDetector(
            //       onTap: () {
            //         Get.to(() => const NotificationScreen());
            //       },
            //       child: Container(
            //         width: 36.w,
            //         height: 36.w,
            //         decoration: const BoxDecoration(
            //           color: AppColors.buttoncolour,
            //           shape: BoxShape.circle,
            //         ),
            //         child: Icon(
            //           Icons.notifications_outlined,
            //           size: 20.sp,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            16.verticalSpace,
            _levelTabBar(),
            14.verticalSpace,
            _levelModulesCard(),
            16.verticalSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styledText("Video of the Week", TextType.font16700),
                  8.verticalSpace,
                  _videoOfWeekPlayer(),
                  8.verticalSpace,
                  Text(
                    _videoOfWeekSubtitle,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF6E6E6E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelTabBar() {
    final planCtrl = Get.find<HomePlanModulesController>();
    return Obx(() {
      final selectedIndex = planCtrl.selectedLevelIndex.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          children: [
            Expanded(
              child: _levelTab(
                planCtrl: planCtrl,
                index: 0,
                selectedIndex: selectedIndex,
                label: "Level 1",
                showRightDivider: true,
              ),
            ),
            Expanded(
              child: _levelTab(
                planCtrl: planCtrl,
                index: 1,
                selectedIndex: selectedIndex,
                label: "Level 2",
                showRightDivider: true,
              ),
            ),
            Expanded(
              child: _levelTab(
                planCtrl: planCtrl,
                index: 2,
                selectedIndex: selectedIndex,
                label: "Level 3",
                showRightDivider: false,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _levelTab({
    required HomePlanModulesController planCtrl,
    required int index,
    required int selectedIndex,
    required String label,
    required bool showRightDivider,
  }) {
    final selected = selectedIndex == index;
    final borderColor = selected ? _tealPrimary : const Color(0xFFE0E0E0);

    return GestureDetector(
      onTap: () => planCtrl.onLevelTabTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? _selectedTabBg : _inactiveTabBg,
          border: Border(
            right:
                showRightDivider
                    ? BorderSide(color: borderColor, width: 1)
                    : BorderSide.none,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: selected ? _tealPrimary : _inactiveTabText,
          ),
        ),
      ),
    );
  }

  Widget _levelModulesCard() {
    final planCtrl = Get.find<HomePlanModulesController>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.buttoncolour,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(() {
        if (planCtrl.isLoading.value) {
          return const _PlanModulesCardShimmer();
        }
        if (planCtrl.errorMessage.value != null) {
          return _planModulesError(planCtrl);
        }
        if (planCtrl.sections.isEmpty) {
          return Text(
            'No lessons available for this plan yet.',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              planCtrl.headerTitle,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            if (planCtrl.totalLessons.value > 0) ...[
              4.verticalSpace,
              Text(
                '${planCtrl.totalLessons.value} lessons',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
            12.verticalSpace,
            ...planCtrl.sections.map((s) => _moduleTile(context, planCtrl, s)),
          ],
        );
      }),
    );
  }

  Widget _planModulesError(HomePlanModulesController planCtrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Could not load plan',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        8.verticalSpace,
        Text(
          planCtrl.errorMessage.value ?? '',
          style: GoogleFonts.inter(fontSize: 13.sp, color: Colors.white70),
        ),
        12.verticalSpace,
        TextButton(
          onPressed: planCtrl.retry,
          child: Text(
            'Retry',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _moduleTile(
    BuildContext context,
    HomePlanModulesController planCtrl,
    PlanLevelSection section,
  ) {
    final showTrial = planCtrl.showFreeTrialFor(section);
    final levelIdx = planCtrl.selectedLevelIndex.value;
    final levelTitle = planCtrl.levelLabelForIndex(levelIdx);
    final amount = planCtrl.dialogAmountForLevel(levelIdx);

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          if (showTrial) {
            _showFreeTrialDialog(
              context: context,
              level: levelTitle,
              amount: amount,
            );
            return;
          }
          if (planCtrl.isBeltLocked(section)) {
            Get.to(() => const PurchasePlanScreen());
            return;
          }
          final bid = section.beltId;
          final btitle = section.beltTitle;
          if (levelIdx == 0) {
            Get.to(() => LevelOneScreen(beltId: bid, beltTitle: btitle));
          } else if (levelIdx == 1) {
            Get.to(() => LevelTwoScreen(beltId: bid, beltTitle: btitle));
          } else {
            Get.to(() => LevelThreeScreen(beltId: bid, beltTitle: btitle));
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: _moduleTileBg,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  section.beltTitle,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (showTrial)
                Text(
                  "Start your free trial",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                )
              else if (planCtrl.isBeltLocked(section))
                Icon(Icons.lock, size: 18.sp, color: _lockColor)
              else
                Icon(
                  Icons.play_circle_outline,
                  size: 20.sp,
                  color: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFreeTrialDialog({
    required BuildContext context,
    required String level,
    required String amount,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            padding: EdgeInsets.fromLTRB(12.w, 18.h, 12.w, 16.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                styledText("Start Your Free Trial", TextType.font20700),
                8.verticalSpace,
                styledText(
                  level,
                  TextType.font20700,
                  color: AppColors.buttoncolour,
                ),
                14.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Payable on Mar 2, 2026: ",
                        style: TextStyle(
                          color: const Color(0xFF7D7D7D),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: amount,
                        style: TextStyle(
                          color: const Color(0xFF333333),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                16.verticalSpace,
                AppButton(
                  text: "Try free for 7 days",
                  textColor: AppColors.whiteColor,
                  backgroundColor: const Color(0xFF3CB471),
                  onPress: () {
                    Get.back();
                    if (level == "Level 1") {
                      Get.to(
                        () => const LevelOneScreen(
                          beltId: 0,
                          beltTitle: 'Foundations & Intro',
                        ),
                      );
                    }
                  },
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    Get.to(() => const PurchasePlanScreen());
                  },
                  behavior: HitTestBehavior.opaque,
                  child: styledText(
                    "Or skip trial pay now",
                    TextType.font16500,
                    color: AppColors.buttoncolour,
                    textDecoration: TextDecoration.underline,
                    textDecorationColor: AppColors.buttoncolour,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton for plan title + module rows while [HomePlanModulesController] loads.
class _PlanModulesCardShimmer extends StatelessWidget {
  const _PlanModulesCardShimmer();

  static const _base = Color(0xFF014A5C);
  static const _highlight = Color(0xFF027A96);

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
            width: 0.55.sw,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          8.verticalSpace,
          Container(
            width: 0.28.sw,
            height: 12.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          12.verticalSpace,
          ...List.generate(6, (i) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                width: double.infinity,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
