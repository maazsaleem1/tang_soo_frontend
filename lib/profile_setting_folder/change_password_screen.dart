import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_status_dialog.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/utils/field_validator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late final AuthController _auth;

  @override
  void initState() {
    super.initState();
    _auth =
        Get.isRegistered<AuthController>()
            ? Get.find<AuthController>()
            : Get.put(AuthController(), permanent: true);
  }

  Future<void> _onSave() async {
    final ok = await _auth.changePasswordFromProfile();
    if (!mounted || !ok) return;

    showCustomStatusDialog(
      context: context,
      message: "Your Password Has\nBeen Changed",
      iconPath: "assets/images/tickicon.svg",
    );

    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    Get.offAll(() => const NavBarScreen(initialIndex: 3));
  }

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
        child: Form(
          key: _auth.changePasswordProfileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              40.verticalSpace,
              AppInput(
                controller: _auth.oldPasswordController,
                validator: _auth.validatePassword,
                placeHolder: "Enter your current password",
                label: "Current Password",
                obscureText: true,
                showPasswordIcon: true,
              ),
              AppInput(
                controller: _auth.newPasswordController,
                validator: _auth.validatePassword,
                placeHolder: "Enter new password",
                label: "New Password",
                obscureText: true,
                showPasswordIcon: true,
              ),
              AppInput(
                controller: _auth.resetConfirmPasswordController,
                validator:
                    (value) => validate(
                      value ?? '',
                      'Confirm Password',
                      password: _auth.newPasswordController.text,
                    ),
                placeHolder: "Confirm new password",
                label: "Confirm Password",
                obscureText: true,
                showPasswordIcon: true,
              ),
              Obx(() {
                return AppButton(
                  onPress: _onSave,
                  text: "Save Password",
                  buttonLoader: _auth.isResetPasswordLoading.value,
                  backgroundColor: AppColors.buttoncolour,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
