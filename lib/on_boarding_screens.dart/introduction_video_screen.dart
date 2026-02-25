import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/navbar_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/training_journey_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  final navBarController = Get.put(NavBarController());
  Timer? _skipTimer;
  bool _hasPressedContinue = false;
  bool _showSkipButton = false;

  void _onContinueTap() {
    if (_hasPressedContinue) return;

    setState(() {
      _hasPressedContinue = true;
    });

    _skipTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;
      setState(() {
        _showSkipButton = true;
      });
    });
  }

  void _goToHome() {
    navBarController.itemSelect(0);
    Get.offAll(() => const NavBarScreen());
    // Get.off(() => const TrainingJourneyScreen());
  }

  @override
  void dispose() {
    _skipTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomVideoPlayer(
            videoSource: 'assets/video/introductionvideo.mp4',
            isAsset: true,
            autoPlay: true,
            showControls: false,
            allowFullScreen: false,
            height: 1.sh,
            width: 1.sw,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:
                !_hasPressedContinue
                    ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16.w, 100.h, 16.w, 28.h),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xCC001B4A)],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styledText(
                            "Welcome to Tang Soo Karate",
                            TextType.font16600,
                            color: Colors.white,
                          ),
                          6.verticalSpace,
                          styledText(
                            "watch this introduction before starting your journey",
                            TextType.font12400,
                            color: const Color(0xFFDDE7FF),
                          ),
                          14.verticalSpace,
                          AppButton(
                            onPress: _onContinueTap,
                            text: "Continue",
                            horizontalMargin: 0,
                            backgroundColor: const Color(0xFF38B26E),
                          ),
                        ],
                      ),
                    )
                    : Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child:
                          _showSkipButton
                              ? AppButton(
                                onPress: _goToHome,
                                text: "Skip",
                                horizontalMargin: 0,
                                backgroundColor: AppColors.buttoncolour,
                                minWidth: 120.w,
                              )
                              : styledText(
                                "you can skip in 5 second",
                                TextType.font12400,
                                color: Colors.white,
                              ),
                    ),
          ),
        ],
      ),
    );
  }
}
