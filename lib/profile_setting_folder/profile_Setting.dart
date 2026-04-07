import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/models/user_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/profile_setting_folder/change_password_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/edit_profile_screen.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/purchase_plan_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/payment_history_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/unlocked_belts_screen.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<AuthController>()) {
        Get.find<AuthController>().loadStoredUser();
      }
    });
  }

  static String _subtitleLine(UserModel? u) {
    if (u == null) return 'Member';
    final sub = u.subscriptionStatus.trim();
    if (sub.isNotEmpty && sub.toLowerCase() != 'null') {
      return sub;
    }
    if (u.role.isNotEmpty) return u.role;
    return 'Member';
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        Get.isRegistered<AuthController>()
            ? Get.find<AuthController>()
            : Get.put(AuthController(), permanent: true);

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          child: Column(
            children: [
              Obx(() {
                final u = auth.currentUser.value;
                final name =
                    (u?.fullName.trim().isNotEmpty ?? false)
                        ? u!.fullName.trim()
                        : 'User';
                final avatarUrl = ApiConfig.absoluteMediaUrl(
                  u?.profileImageUrl,
                );

                return Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 58.w,
                        height: 58.w,
                        color: const Color(0xFFEDEDED),
                        child:
                            avatarUrl != null
                                ? Image.network(
                                  avatarUrl,
                                  width: 58.w,
                                  height: 58.w,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Center(
                                        child: SvgPicture.asset(
                                          'assets/images/profile_avatar.svg',
                                          width: 30.w,
                                          height: 30.w,
                                        ),
                                      ),
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                      child: SizedBox(
                                        width: 22.w,
                                        height: 22.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          value:
                                              progress.expectedTotalBytes !=
                                                      null
                                                  ? progress
                                                          .cumulativeBytesLoaded /
                                                      progress
                                                          .expectedTotalBytes!
                                                  : null,
                                        ),
                                      ),
                                    );
                                  },
                                )
                                : Center(
                                  child: SvgPicture.asset(
                                    'assets/images/profile_avatar.svg',
                                    width: 30.w,
                                    height: 30.w,
                                  ),
                                ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styledText(name, TextType.font16500),
                          2.verticalSpace,
                          styledText(
                            _subtitleLine(u),
                            TextType.font12400,
                            color: AppColors.newtextcolor,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Get.to(() => const EditProfileScreen());
                        await auth.loadStoredUser();
                      },
                      child: Container(
                        width: 28.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: const Color(0xFFEAF8FF),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/editprofileicon.svg',
                            width: 16.w,
                            height: 16.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              16.verticalSpace,
              _menuCard(
                iconPath: "assets/images/unlockedbelticon.svg",
                title: "Unlocked Belts",
                onTap: () {
                  Get.to(() => const UnlockedBeltsScreen());
                },
              ),
              10.verticalSpace,
              _menuCard(
                iconPath: "assets/images/payemnticon.svg",
                title: "Purchase Plan",
                onTap: () {
                  Get.to(() => const PurchasePlanScreen());
                },
              ),
              10.verticalSpace,
              _menuCard(
                iconPath: "assets/images/payemnticon.svg",
                title: "Payment History",
                onTap: () {
                  Get.to(() => const PaymentHistoryScreen());
                },
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
                        Get.to(() => const ChangePasswordScreen());
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
                onTap: () async {
                  await auth.logout();
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
