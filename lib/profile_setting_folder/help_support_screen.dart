import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/profile_setting_folder/contact_support_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/faq_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Help & Support",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.back();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            styledText("We’re here to help you", TextType.font20700),
            20.verticalSpace,
            _helpCard(
              icon: Icons.question_mark_rounded,
              iconColor: const Color(0xFFFF3A3A),
              title: "FAQs",
              onTap: () {
                Get.to(() => const FaqScreen());
              },
            ),
            14.verticalSpace,
            _helpCard(
              icon: Icons.chat_bubble_outline_rounded,
              iconColor: const Color(0xFF9A9A9A),
              title: "Contact Support",
              onTap: () {
                Get.to(() => const ContactSupportScreen());
              },
            ),
            36.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.w,
                  child: styledText(
                    "Support Email:",
                    TextType.font14400,
                    color: const Color(0xFF797979),
                  ),
                ),
                Expanded(
                  child: styledText(
                    "tangsookarateapp@gmail.com",
                    TextType.font16500,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100.w,
                  child: styledText(
                    "Address:",
                    TextType.font14400,
                    color: const Color(0xFF797979),
                  ),
                ),
                Expanded(
                  child: styledText(
                    "400 Laurel Oak Rd Ste 106\nVoorhees, NJ 08043",
                    TextType.font16500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _helpCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: const Color(0xFFE9E9E9)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            10.horizontalSpace,
            styledText(title, TextType.font16500),
          ],
        ),
      ),
    );
  }
}
