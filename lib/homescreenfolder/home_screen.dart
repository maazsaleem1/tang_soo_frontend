import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/custom_widgets.dart/video_of_week_embed.dart';
import 'package:tang_soo_karate/models/video_of_week_model.dart';
import 'package:tang_soo_karate/services/lessons/lesson_service.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/purchase_plan_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class _ModuleTileData {
  final String title;
  final bool showFreeTrialLink;

  const _ModuleTileData({required this.title, this.showFreeTrialLink = false});
}

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

  int _selectedLevelIndex = 0;

  static const List<_ModuleTileData> _level1Modules = [
    _ModuleTileData(title: "Foundations & Intro", showFreeTrialLink: true),
    _ModuleTileData(title: "White Belt"),
    _ModuleTileData(title: "Yellow & Orange Progression"),
    _ModuleTileData(title: "Green Belt"),
    _ModuleTileData(title: "Red Belt"),
    _ModuleTileData(title: "Cho Dan Bo / Pre-Black Belt Prep"),
    _ModuleTileData(title: "Weapons Introduction"),
  ];

  static const List<_ModuleTileData> _level2Modules = [
    _ModuleTileData(title: "Intermediate Foundations"),
    _ModuleTileData(title: "Blue Belt Path"),
    _ModuleTileData(title: "Advanced Combinations"),
    _ModuleTileData(title: "Sparring Basics"),
    _ModuleTileData(title: "Forms Level 2"),
    _ModuleTileData(title: "Breaking Techniques"),
    _ModuleTileData(title: "Instructor Prep"),
  ];

  static const List<_ModuleTileData> _level3Modules = [
    _ModuleTileData(title: "Advanced Mastery"),
    _ModuleTileData(title: "Black Belt Curriculum"),
    _ModuleTileData(title: "Weapons Advanced"),
    _ModuleTileData(title: "Teaching Modules"),
    _ModuleTileData(title: "Tournament Prep"),
    _ModuleTileData(title: "Leadership Training"),
    _ModuleTileData(title: "Certification Track"),
  ];

  List<_ModuleTileData> get _currentModules {
    switch (_selectedLevelIndex) {
      case 0:
        return _level1Modules;
      case 1:
        return _level2Modules;
      default:
        return _level3Modules;
    }
  }

  String get _currentLevelTitle => "Level ${_selectedLevelIndex + 1}";

  String get _dialogAmount {
    switch (_selectedLevelIndex) {
      case 0:
        return "\$4.99";
      case 1:
        return "\$5.99";
      default:
        return "\$6.99";
    }
  }

  @override
  void initState() {
    super.initState();
    _loadVideoOfTheWeek();
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Row(
        children: [
          Expanded(
            child: _levelTab(
              index: 0,
              label: "Level 1",
              showRightDivider: true,
            ),
          ),
          Expanded(
            child: _levelTab(
              index: 1,
              label: "Level 2",
              showRightDivider: true,
            ),
          ),
          Expanded(
            child: _levelTab(
              index: 2,
              label: "Level 3",
              showRightDivider: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _levelTab({
    required int index,
    required String label,
    required bool showRightDivider,
  }) {
    final selected = _selectedLevelIndex == index;
    final borderColor = selected ? _tealPrimary : const Color(0xFFE0E0E0);

    return GestureDetector(
      onTap: () {
        if (index == 1 || index == 2) {
          Get.to(() => const PurchasePlanScreen());
          return;
        }
        setState(() => _selectedLevelIndex = index);
      },
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 14.h),
      decoration: BoxDecoration(
        color: AppColors.buttoncolour,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentLevelTitle,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          12.verticalSpace,
          ..._currentModules.map(_moduleTile),
        ],
      ),
    );
  }

  Widget _moduleTile(_ModuleTileData data) {
    final bool showTrial = _selectedLevelIndex == 0 && data.showFreeTrialLink;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () {
          _showFreeTrialDialog(
            level: _currentLevelTitle,
            amount: _dialogAmount,
          );
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
                  data.title,
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
              else
                Icon(Icons.lock, size: 18.sp, color: _lockColor),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFreeTrialDialog({
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
                      Get.to(() => const LevelOneScreen());
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
