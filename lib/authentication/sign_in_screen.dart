import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/authentication/forgot_password_screen.dart';
import 'package:tang_soo_karate/authentication/signup_screen.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/controllers/navbar_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final Logincontroller logincontroller = Get.put(Logincontroller());
  final navabrcontroller = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Log In",
        textType: TextType.font16600,
        showBack: false,
        onPress: () {},
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: styledText(
                    "Please enter your credentials to login",
                    TextType.font14400,
                  ),
                ),
                20.verticalSpace,
                AppInput(
                  placeHolder: "Enter your email address",
                  label: "Email Address",
                ),
                Obx(() {
                  return AppInput(
                    placeHolder: "Enter your password",
                    label: "Password",
                    obscureText: logincontroller.isPasswordVisible.value,
                    showPasswordIcon: true,
                    onTap: () {},
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          return GestureDetector(
                            onTap: () {
                              logincontroller.isChecked.value =
                                  !logincontroller.isChecked.value;
                            },
                            child: Container(
                              height: 17.h,
                              width: 17.h,
                              decoration: BoxDecoration(
                                color: Color(0xff09CA67),
                                border: Border.all(
                                  width: 1,
                                  color: Color(0xff09CA67),
                                ),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child:
                                  logincontroller.isChecked.value
                                      ? Icon(
                                        Icons.check,
                                        size: 15.sp,
                                        color: AppColors.whiteColor,
                                      )
                                      : const SizedBox.shrink(),
                            ),
                          );
                        }),
                        10.horizontalSpace,
                        styledText("Remember Me?", TextType.font14400),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const ForgotPasswordScreen());
                      },
                      child: styledText(
                        "Forgot Password?",
                        color: AppColors.hintstylecolour,
                        TextType.font12400,
                      ),
                    ),
                  ],
                ),
                24.verticalSpace,
                AppButton(
                  text: "Login",
                  onPress: () {
                    Get.offAll(NavBarScreen());
                    navabrcontroller.itemSelect(0);
                  },
                ),
                24.verticalSpace,
                styledText(
                  "OR",
                  TextType.font16600,
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
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
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                styledText("Don't have an account?", TextType.font14400),
                3.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    Get.to(() => SignupScreen());
                  },
                  child: styledText("Signup", TextType.font16600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
