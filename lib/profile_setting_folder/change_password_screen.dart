import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_status_dialog.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Change Password",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.close(1);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            40.verticalSpace,
            AppInput(
              placeHolder: "Enter your current password",
              label: "Current Password",
              obscureText: true,
              showPasswordIcon: true,
            ),
            AppInput(
              placeHolder: "Enter new password",
              label: "New Password",
              obscureText: true,
              showPasswordIcon: true,
            ),
            AppInput(
              placeHolder: "Confirm new password",
              label: "Confirm Password",
              obscureText: true,
              showPasswordIcon: true,
            ),
            AppButton(
              onPress: () {
                showCustomStatusDialog(
                  context: context,
                  message: "Your Password Has\nBeen Changed",
                  iconPath: "assets/images/tickicon.svg",
                );

                Future.delayed(const Duration(seconds: 2), () {
                  if (!mounted) return;
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                  Get.offAll(() => const NavBarScreen(initialIndex: 3));
                });
              },
              text: "Save Password",
              backgroundColor: AppColors.buttoncolour,
            ),
          ],
        ),
      ),
    );
  }
}
