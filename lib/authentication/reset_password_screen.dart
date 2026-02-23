import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/authentication/sign_in_screen.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundcolour,
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.verticalSpace,
              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Get.off(() => SignInScreen());
              //       },
              //       child: SvgPicture.asset("assets/images/backicon.svg"),
              //     ),
              //     SizedBox(
              //       width: 0.8.sw,
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           styledText(
              //             "Reset Password",
              //             TextType.xlarge,
              //             textAlign: TextAlign.center,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              10.verticalSpace,
              styledText(
                "Please enter your new password",
                TextType.font14400,
                textAlign: TextAlign.center,
              ),
              40.verticalSpace,
              AppInput(
                placeHolder: "Enter new password",
                label: "New Password",
              ),
              AppInput(
                placeHolder: "Confirm new password",
                label: "Confirm Password",
              ),
              AppButton(
                onPress: () {
                  Get.offAll(() => SignInScreen());
                },
                text: "Continue",
                backgroundColor: AppColors.buttoncolour,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
