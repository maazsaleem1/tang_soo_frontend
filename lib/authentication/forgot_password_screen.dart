import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
        title: "Forgot Password",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.close(1);
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: authController.forgotPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              100.verticalSpace,
              styledText(
                "Please enter your email to reset your password",
                TextType.font14400,
                textAlign: TextAlign.center,
              ),
              25.verticalSpace,
              AppInput(
                controller: authController.forgotPasswordEmailController,
                validator: authController.validateEmail,
                placeHolder: "Enter your email address",
                label: "Email Address",
              ),

              Obx(() {
                return AppButton(
                  onPress: authController.forgotPassword,
                  text: "Continue",
                  buttonLoader: authController.isForgotPasswordLoading.value,
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
