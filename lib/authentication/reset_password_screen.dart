import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/utils/field_validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final AuthController authController;

  @override
  void initState() {
    super.initState();
    authController =
        Get.isRegistered<AuthController>()
            ? Get.find<AuthController>()
            : Get.put(AuthController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Reset Password",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.close(1);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: authController.resetPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.verticalSpace,
              styledText(
                "Please enter your old and new password",
                TextType.font14400,
                textAlign: TextAlign.center,
              ),
              40.verticalSpace,
              AppInput(
                controller: authController.oldPasswordController,
                validator: authController.validatePassword,
                placeHolder: "Enter old password",
                label: "Old Password",
                obscureText: true,
              ),
              AppInput(
                controller: authController.newPasswordController,
                validator: authController.validatePassword,
                placeHolder: "Enter new password",
                label: "New Password",
                obscureText: true,
              ),
              AppInput(
                controller: authController.resetConfirmPasswordController,
                validator:
                    (value) => validate(
                      value ?? '',
                      'Confirm Password',
                      password: authController.newPasswordController.text,
                    ),
                placeHolder: "Confirm new password",
                label: "Confirm Password",
                obscureText: true,
              ),
              Obx(() {
                return AppButton(
                  onPress: authController.resetPassword,
                  text: "Continue",
                  buttonLoader: authController.isResetPasswordLoading.value,
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
