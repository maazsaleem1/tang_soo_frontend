import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Log In",
        textType: TextType.medium,
        showBack: true,
        onPress: () {},
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/backgroundimage.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  styledText(
                    "Please enter your credentials to login",
                    TextType.font14400,
                  ),
                  55.verticalSpace,
                  AppInput(
                    placeHolder: "Enter your email address",
                    label: "Email Address",
                  ),
                  AppInput(
                    placeHolder: "Enter your password",
                    label: "Password",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // Obx(() {
                          //   return GestureDetector(
                          //     onTap: () {
                          //       logincontroller.isChecked.value =
                          //           !logincontroller.isChecked.value;
                          //     },
                          //     child: Container(
                          //       height: 17.h,
                          //       width: 17.h,
                          //       decoration: BoxDecoration(
                          //         color: AppColors.whiteColor,
                          //         border: Border.all(
                          //           width: 1,
                          //           color: AppColors.bordercolour,
                          //         ),
                          //         borderRadius: BorderRadius.circular(5.r),
                          //       ),
                          //       child:
                          //           logincontroller.isChecked.value
                          //               ? Icon(
                          //                 Icons.check,
                          //                 size: 15.sp,
                          //                 color: AppColors.blackColor,
                          //               )
                          //               : const SizedBox.shrink(),
                          //     ),
                          //   );
                          // }),
                          10.horizontalSpace,
                          styledText("Remember Me?", TextType.font14400),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Get.to(() => const ForgotPasswordScreen());
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
                  AppButton(text: "Login", onPress: () {}),
                  24.verticalSpace,
                  styledText(
                    "OR",
                    TextType.medium,
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Platform.isIOS
                      //     ? SvgPicture.asset('assets/images/applelogo.svg')
                      //     : const SizedBox.shrink(),
                      // Platform.isIOS ? 20.horizontalSpace : 0.horizontalSpace,
                      // Platform.isAndroid
                      //     ? SvgPicture.asset('assets/images/googlelogo.svg')
                      //     : const SizedBox.shrink(),
                      // Platform.isAndroid
                      //     ? 20.horizontalSpace
                      //     : 0.horizontalSpace,
                      // SvgPicture.asset('assets/images/facebooklogo.svg'),
                    ],
                  ),
                ],
              ),
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
                    // Get.to(() => SignupScreen());
                  },
                  child: styledText("Signup", TextType.medium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
