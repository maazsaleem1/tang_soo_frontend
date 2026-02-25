import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/homescreenfolder/level_one_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  styledText(
                    "Current Level 1",
                    TextType.font12400,
                    color: const Color(0xFF9B9B9B),
                  ),
                  const Spacer(),

                  SvgPicture.asset("assets/images/Redbelt.svg"),
                ],
              ),
              4.verticalSpace,
              styledText("Beginner to Red Belt", TextType.font16600),
              12.verticalSpace,
              Row(
                children: [
                  styledText(
                    "Lessons Completed",
                    TextType.font12400,
                    color: const Color(0xFF9B9B9B),
                  ),
                  const Spacer(),
                  styledText("2/52", TextType.font16500),
                ],
              ),
              12.verticalSpace,
              Row(
                children: [
                  styledText("Belt Progression", TextType.font14500),
                  const Spacer(),
                  styledText("20%", TextType.font14500),
                ],
              ),
              6.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(30.r),
                child: const LinearProgressIndicator(
                  value: 0.2,
                  minHeight: 6,
                  backgroundColor: Color(0xFFD9D9D9),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
                ),
              ),
              8.verticalSpace,
              styledText(
                "You're 33% closer to your next belt!",
                TextType.font12400,
                color: const Color(0xFF9B9B9B),
              ),
              20.verticalSpace,
              styledText("Next Levels", TextType.font20700),
              10.verticalSpace,
              _levelRow(
                title: "Level 1",
                trailing: styledText(
                  "Unlocked",
                  TextType.font14600,
                  color: AppColors.buttoncolour,
                  textDecoration: TextDecoration.underline,
                  textDecorationColor: AppColors.buttoncolour,
                ),
                onTap: () {
                  _showFreeTrialDialog(level: "Level 1", amount: "\$4.99");
                },
              ),
              8.verticalSpace,
              _levelRow(
                title: "Level 2",
                trailing: Row(
                  children: [
                    const Icon(Icons.lock, size: 14, color: Color(0xFFF7A600)),
                    14.horizontalSpace,
                    styledText("\$5.99", TextType.font14500),
                  ],
                ),
                onTap: () {
                  _showFreeTrialDialog(level: "Level 2", amount: "\$5.99");
                },
              ),
              8.verticalSpace,
              _levelRow(
                title: "Level 3",
                trailing: Row(
                  children: [
                    const Icon(Icons.lock, size: 14, color: Color(0xFFF7A600)),
                    14.horizontalSpace,
                    styledText("\$6.99", TextType.font14500),
                  ],
                ),
                onTap: () {
                  _showFreeTrialDialog(level: "Level 3", amount: "\$6.99");
                },
              ),
            ],
          ),
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
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            styledText(title, TextType.font16500),
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
