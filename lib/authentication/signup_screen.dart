import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/authentication/sign_in_screen.dart';
import 'package:tang_soo_karate/authentication/verify_otp_screen.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final Logincontroller logincontroller = Get.put(Logincontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Sign Up",
        textType: TextType.medium,
        showBack: true,
        onPress: () {
          Get.off(() => SignInScreen());
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  25.verticalSpace,
                  AppInput(
                    placeHolder: "Enter your first name",
                    label: "First Name",
                  ),
                  AppInput(
                    placeHolder: "Enter your last name",
                    label: "Last Name",
                  ),
                  AppInput(
                    placeHolder: "Enter your email address",
                    label: "Email ",
                  ),

                  Obx(() {
                    return AppInput(
                      placeHolder: "Enter your password",
                      label: "Create Password",
                      obscureText: logincontroller.isPasswordVisible.value,
                      showPasswordIcon: true,
                      onTap: () {},
                    );
                  }),
                  Obx(() {
                    return AppInput(
                      placeHolder: "Confirm your password",
                      label: "Confirm Password",
                      obscureText: logincontroller.isPasswordVisible.value,
                      showPasswordIcon: true,
                      onTap: () {},
                    );
                  }),
                  styledText(
                    "We’ll send an email with code to email verification ",
                    TextType.font14400,
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  AppButton(
                    text: "Create Account",
                    onPress: () {
                      Get.to(() => VerifyOtpScreen(page: 'createaccount'));
                    },
                  ),

                  10.verticalSpace,
                  styledText(
                    "OR",
                    TextType.medium,
                    textAlign: TextAlign.center,
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Platform.isIOS
                          ? SvgPicture.asset(SvgIcons.applelogo)
                          : const SizedBox.shrink(),
                      Platform.isIOS ? 20.horizontalSpace : 0.horizontalSpace,
                      Platform.isAndroid
                          ? SvgPicture.asset(SvgIcons.googlelogo)
                          : const SizedBox.shrink(),
                      // Platform.isAndroid
                      //     ? 20.horizontalSpace
                      //     : 0.horizontalSpace,
                      // SvgPicture.asset('assets/images/facebooklogo.svg'),
                    ],
                  ),
                  5.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      styledText(
                        "Already have an account?",
                        TextType.font14400,
                      ),
                      3.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          Get.off(() => SignInScreen());
                        },
                        child: styledText("Sign In", TextType.medium),
                      ),
                    ],
                  ),
                  30.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
