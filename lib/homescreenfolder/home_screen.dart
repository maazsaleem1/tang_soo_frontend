import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/customize_video_player.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            //       width: 34.w,
            //       height: 34.w,
            //       decoration: const BoxDecoration(shape: BoxShape.circle),
            //       child: ClipOval(
            //         child: SvgPicture.asset(
            //           "assets/images/profile_avatar.svg",
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //     8.horizontalSpace,
            //     styledText("Welcome, John!", TextType.font14500),
            //     const Spacer(),
            //     Container(
            //       width: 28.w,
            //       height: 28.w,
            //       decoration: const BoxDecoration(
            //         color: AppColors.buttoncolour,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Icon(
            //         Icons.notifications,
            //         size: 16.sp,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ],
            // ),
            14.verticalSpace,
            styledText("Your Karate Journey Starts Here", TextType.font20700),
            12.verticalSpace,
            _levelRow(
              title: "Level 1",
              onTap: () {
                _showFreeTrialDialog(level: "Level 1", amount: "\$4.99");
              },
              trailing: styledText(
                "Start Your Free Trial",
                TextType.font12400,
                color: AppColors.buttoncolour,
                textDecoration: TextDecoration.underline,
                textDecorationColor: AppColors.buttoncolour,
              ),
            ),
            8.verticalSpace,
            _levelRow(
              title: "Level 2",
              onTap: () {
                _showFreeTrialDialog(level: "Level 2", amount: "\$5.99");
              },
              trailing: Row(
                children: [
                  const Icon(Icons.lock, size: 12, color: Color(0xFFF7A600)),
                  14.horizontalSpace,
                  styledText("\$5.99", TextType.font14500),
                ],
              ),
            ),
            8.verticalSpace,
            _levelRow(
              title: "Level 3",
              onTap: () {
                _showFreeTrialDialog(level: "Level 3", amount: "\$6.99");
              },
              trailing: Row(
                children: [
                  const Icon(Icons.lock, size: 12, color: Color(0xFFF7A600)),
                  14.horizontalSpace,
                  styledText("\$6.99", TextType.font14500),
                ],
              ),
            ),
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
                  ClipRRect(
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
                  ),
                  // Container(
                  //   width: double.infinity,
                  //   height: 100.h,
                  //   decoration: BoxDecoration(
                  //     color: const Color(0xFF6E6E6E),
                  //     borderRadius: BorderRadius.circular(10.r),
                  //   ),
                  //   child: Stack(
                  //     alignment: Alignment.center,
                  //     children: [
                  //       ClipRRect(
                  //         borderRadius: BorderRadius.circular(10.r),
                  //         child: Image.asset(
                  //           "assets/images/splashscreen.png",
                  //           fit: BoxFit.cover,
                  //           width: double.infinity,
                  //           height: double.infinity,
                  //         ),
                  //       ),
                  //       Container(
                  //         width: 40.w,
                  //         height: 40.w,
                  //         decoration: const BoxDecoration(
                  //           color: Color(0xFFFF4D4D),
                  //           shape: BoxShape.circle,
                  //         ),
                  //         child: Icon(
                  //           Icons.play_arrow,
                  //           size: 24.sp,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  8.verticalSpace,
                  styledText(
                    "Situational Awareness - Lesson of the Week",
                    TextType.font14500,
                    color: const Color(0xFF6E6E6E),
                  ),
                ],
              ),
            ),
            12.verticalSpace,
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
              decoration: BoxDecoration(
                color: AppColors.buttoncolour,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styledText(
                    "Training",
                    TextType.font20700,
                    color: Colors.white,
                  ),
                  8.verticalSpace,
                  _lessonRow("Lesson 1:", "Warm-Up"),
                  8.verticalSpace,
                  _lessonRow("Lesson 2:", "Basic Kicks"),
                  8.verticalSpace,
                  _lessonRow("Lesson 3:", "One-Steps"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelRow({
    required String title,
    required Widget trailing,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFECECEC),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            styledText(title, TextType.font16600),
            8.horizontalSpace,
            Icon(
              Icons.arrow_forward,
              size: 14.sp,
              color: const Color(0xFF3D3D3D),
            ),
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _lessonRow(String left, String right) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xFF005E74),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 68.w,
            child: styledText(left, TextType.font12700, color: Colors.white),
          ),
          Expanded(
            child: styledText(right, TextType.font12700, color: Colors.white),
          ),
          const Icon(Icons.lock, size: 12, color: Color(0xFFF7A600)),
        ],
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
                // Container(
                //   width: double.infinity,
                //   padding: EdgeInsets.symmetric(vertical: 12.h),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF3CB471),
                //     borderRadius: BorderRadius.circular(100.r),
                //   ),
                //   child: Center(
                //     child: styledText(
                //       "Try free for 7 days",
                //       TextType.font16600,
                //       color: AppColors.whiteColor,
                //     ),
                //   ),
                // ),
                10.verticalSpace,
                styledText(
                  "Or skip trial pay now",
                  TextType.font16500,
                  color: AppColors.buttoncolour,
                  textDecoration: TextDecoration.underline,
                  textDecorationColor: AppColors.buttoncolour,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
