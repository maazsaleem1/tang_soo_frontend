import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/introduction_video_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class TrainingJourneyScreen extends StatefulWidget {
  const TrainingJourneyScreen({super.key});

  @override
  State<TrainingJourneyScreen> createState() => _TrainingJourneyScreenState();
}

class _TrainingJourneyScreenState extends State<TrainingJourneyScreen> {
  bool _isMonthly = true;

  @override
  Widget build(BuildContext context) {
    final String durationLabel = _isMonthly ? "/month" : "/year";
    final String level1Amount = _isMonthly ? "\$4.99" : "\$59.88";
    final String level2Amount = _isMonthly ? "\$5.99" : "\$71.88";
    final String level3Amount = _isMonthly ? "\$6.99" : "\$83.88";

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.w, 12.h, 10.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  styledText("Payment", TextType.font16600),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.off(() => const IntroductionScreen());
                    },
                    child: styledText(
                      "Start Your Free Trial",
                      TextType.font14600,
                      color: AppColors.buttoncolour,
                      textDecoration: TextDecoration.underline,
                      textDecorationColor: AppColors.buttoncolour,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              styledText("Choose Your Training Journey", TextType.font20700),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMonthly = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color:
                                _isMonthly
                                    ? const Color(0xFFD6E4E9)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: styledText(
                              "Monthly",
                              TextType.font16500,
                              color:
                                  _isMonthly
                                      ? AppColors.buttoncolour
                                      : const Color(0xFFB2B2B2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isMonthly = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            color:
                                !_isMonthly
                                    ? const Color(0xFFD6E4E9)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Center(
                            child: styledText(
                              "Yearly",
                              TextType.font16500,
                              color:
                                  !_isMonthly
                                      ? AppColors.buttoncolour
                                      : const Color(0xFFB2B2B2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              12.verticalSpace,
              _planCard(
                title: "Level 1 - Beginner",
                subtitle: "White Belt + Red Belt",
                amount: level1Amount,
                duration: durationLabel,
                points: const [
                  "Fundamentals & Basic Techniques",
                  "Kata (Forms) 1-6",
                  "Kumite (Sparring) Basics",
                  "Video Lessons & Drills",
                  "Community Access",
                ],
                buttonText: "Choose Beginner",
                buttonColor: AppColors.buttoncolour,
                badgeText: "Free Trial",
                badgeSubText: "(only have 3 lessons)",
              ),
              10.verticalSpace,
              _planCard(
                title: "Level 2 - Black Belt",
                subtitle: "1st-3rd Dan",
                amount: level2Amount,
                duration: durationLabel,
                points: const [
                  "Everything in Beginner",
                  "Advanced Kata & Bunkai",
                  "Competition Kumite Strategies",
                  "Personalized Training Plans",
                  "Priority Support",
                ],
                buttonText: "Choose Black Belt",
                buttonColor: const Color(0xFF999999),
                moreText: "+1 more lesson >",
                isLocked: true,
              ),
              10.verticalSpace,
              _planCard(
                title: "Level 3 - Master",
                subtitle: "4th-8th Dan",
                amount: level3Amount,
                duration: durationLabel,
                points: const [
                  "Everything in Black Belt",
                  "Master Level Techniques",
                  "Teaching Methodology",
                  "Dojo Management Tips",
                  "Exclusive Master Classes",
                ],
                buttonText: "Choose Master",
                buttonColor: const Color(0xFF999999),
                isLocked: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _planCard({
    required String title,
    required String subtitle,
    required String amount,
    required String duration,
    required List<String> points,
    required String buttonText,
    required Color buttonColor,
    String? badgeText,
    String? badgeSubText,
    String? moreText,
    bool isLocked = false,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFE5E5E5) : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: styledText(title, TextType.font15500)),
              if (isLocked)
                const Icon(Icons.lock, size: 12, color: Color(0xFFF7A600)),
            ],
          ),
          2.verticalSpace,
          styledText(subtitle, TextType.font10, color: const Color(0xFF8F8F8F)),
          6.verticalSpace,
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: amount,
                  style: TextStyle(
                    color: AppColors.buttoncolour,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: duration,
                  style: TextStyle(
                    color: const Color(0xFF8F8F8F),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          6.verticalSpace,
          styledText("Lessons Included:", TextType.font12400),
          6.verticalSpace,
          ...points.map(
            (point) => Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check,
                    size: 14.sp,
                    color: const Color(0xFF7B7B7B),
                  ),
                  5.horizontalSpace,
                  Expanded(
                    child: styledText(
                      point,
                      TextType.font12400,
                      color: const Color(0xFF595959),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (moreText != null) ...[
            2.verticalSpace,
            styledText(moreText, TextType.font12400, color: Colors.blue),
          ],
          8.verticalSpace,

          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.symmetric(vertical: 8.h),
          //   decoration: BoxDecoration(
          //     color: buttonColor,
          //     borderRadius: BorderRadius.circular(100.r),
          //   ),
          //   child: Center(
          //     child: styledText(
          //       buttonText,
          //       TextType.font12400,
          //       color: AppColors.whiteColor,
          //     ),
          //   ),
          // ),
          AppButton(
            text: buttonText,
            textColor: AppColors.whiteColor,
            backgroundColor: buttonColor,
            onPress: () {},
          ),
          if (badgeText != null && badgeSubText != null) ...[
            6.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                styledText(badgeText, TextType.font12400, color: Colors.blue),
                4.horizontalSpace,
                styledText(
                  badgeSubText,
                  TextType.font10,
                  color: const Color(0xFF8F8F8F),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
