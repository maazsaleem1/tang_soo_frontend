import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/authentication/sign_in_screen.dart';
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
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Sign Up",
        textType: TextType.font16600,
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              ),
              child: Form(
                key: authController.signupFormKey,
                child: Column(
                  children: [
                    25.verticalSpace,
                    AppInput(
                      controller: authController.firstNameController,
                      validator: authController.validateFirstName,
                      placeHolder: "Enter your first name",
                      label: "First Name",
                    ),
                    AppInput(
                      controller: authController.lastNameController,
                      validator: authController.validateLastName,
                      placeHolder: "Enter your last name",
                      label: "Last Name",
                    ),
                    AppInput(
                      controller: authController.emailController,
                      validator: authController.validateEmail,
                      placeHolder: "Enter your email address",
                      label: "Email ",
                    ),
                    Obx(() {
                      return AppInput(
                        controller: authController.passwordController,
                        validator: authController.validatePassword,
                        placeHolder: "Enter your password",
                        label: "Create Password",
                        obscureText:
                            authController.isSignupPasswordObscure.value,
                        showPasswordIcon: true,
                        onTap: authController.toggleSignupPasswordVisibility,
                      );
                    }),
                    Obx(() {
                      return AppInput(
                        controller: authController.confirmPasswordController,
                        validator: authController.validateConfirmPassword,
                        placeHolder: "Confirm your password",
                        label: "Confirm Password",
                        obscureText:
                            authController.isSignupConfirmPasswordObscure.value,
                        showPasswordIcon: true,
                        onTap:
                            authController
                                .toggleSignupConfirmPasswordVisibility,
                      );
                    }),
                    styledText(
                      "We’ll send an email with code to email verification ",
                      TextType.font14400,
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                    Obx(() {
                      return AppButton(
                        text: "Create Account",
                        buttonLoader: authController.isSignupLoading.value,
                        onPress: authController.signup,
                      );
                    }),

                    10.verticalSpace,
                    styledText(
                      "OR",
                      TextType.font16600,
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
                          child: styledText("Sign In", TextType.font16600),
                        ),
                      ],
                    ),
                    30.verticalSpace,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
