import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/authentication/sign_in_screen.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/profile_setting_folder/change_password_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/help_support_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/privacy_policy_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/terms_condition_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => ProfilescreenState();
}

class ProfilescreenState extends State<Profilescreen> {
  bool _isNotificationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 58.w,
                    height: 58.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDEDED),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/profile_avatar.svg",
                        width: 30.w,
                        height: 30.w,
                      ),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styledText("John Doe", TextType.font16500),
                        2.verticalSpace,
                        styledText(
                          "White Belt",
                          TextType.font12400,
                          color: AppColors.newtextcolor,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: const Color(0xFFEAF8FF),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/images/editprofileicon.svg",
                        width: 16.w,
                        height: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              _menuCard(
                iconPath: "assets/images/unlockedbelticon.svg",
                title: "Unlocked Belts",
                onTap: () {},
              ),
              10.verticalSpace,
              _menuCard(
                iconPath: "assets/images/payemnticon.svg",
                title: "Payment History",
                onTap: () {},
              ),
              10.verticalSpace,
              _menuCard(
                iconPath: "assets/images/helpandsuport.svg",
                title: "Help & Support",
                onTap: () {
                  Get.to(() => const HelpSupportScreen());
                },
              ),
              10.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/privacyicon.svg",
                          width: 20.w,
                          height: 20.w,
                        ),
                        12.horizontalSpace,
                        styledText("Privacy Settings", TextType.font16500),
                      ],
                    ),
                    10.verticalSpace,
                    _arrowRow(
                      "Terms & Condition",
                      onTap: () {
                        Get.to(() => const TermsConditionScreen());
                      },
                    ),
                    12.verticalSpace,
                    _arrowRow(
                      "Privacy Policy",
                      onTap: () {
                        Get.to(() => const PrivacyPolicyScreen());
                      },
                    ),
                    12.verticalSpace,
                    _arrowRow(
                      "Change Password",
                      onTap: () {
                        Get.to(() => ChangePasswordScreen());
                      },
                    ),
                  ],
                ),
              ),
              10.verticalSpace,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/notificationicon.svg",
                      width: 20.w,
                      height: 20.w,
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: styledText(
                        "Notification Preferences",
                        TextType.font16500,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: _isNotificationEnabled,
                        onChanged: (value) {
                          setState(() {
                            _isNotificationEnabled = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF3BC27D),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFBEBEBE),
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
              GestureDetector(
                onTap: () {
                  Get.offAll(() => const SignInScreen());
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/logouticon.svg",
                      width: 18.w,
                      height: 18.w,
                    ),
                    10.horizontalSpace,
                    styledText("Log out", TextType.font16600),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuCard({
    required String iconPath,
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, width: 20.w, height: 20.w),
            12.horizontalSpace,
            styledText(title, TextType.font16500),
          ],
        ),
      ),
    );
  }

  Widget _arrowRow(String title, {required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(child: styledText(title, TextType.font16500)),
          Icon(
            Icons.chevron_right,
            size: 20.sp,
            color: const Color(0xFF7B7B7B),
          ),
        ],
      ),
    );
  }
}
