import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String page;
  const VerifyOtpScreen({super.key, required this.page});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late final AuthController authController;
  String _enteredOtp = '';

  Future<void> _submitOtp(String otp) async {
    if (authController.isVerifyOtpLoading.value) return;

    final value = otp.trim();
    if (value.length != 6) return;

    _enteredOtp = value;
    if (widget.page == 'forgotpassword') {
      await authController.verifyForgotPasswordOtp(_enteredOtp);
    } else if (widget.page == 'login') {
      await authController.verifyLoginOtp(_enteredOtp);
    } else {
      await authController.verifyCreateAccountOtp(_enteredOtp);
    }
  }

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
        title: "OTP",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.close(1);
        },
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              50.verticalSpace,
              Row(
                children: [
                  24.horizontalSpace,
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.off(() => LoginScreen());
                  //   },
                  //   child: SvgPicture.asset("assets/images/backicon.svg"),
                  // ),
                  9.horizontalSpace,
                  SizedBox(
                    width: 0.7.sw,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [styledText("OTP", TextType.xlarge)],
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: styledText(
                  "We have sent you an email containing 6 digit of verification code. Please enter the code to verify your identity",
                  TextType.font14400,
                  textAlign: TextAlign.center,
                ),
              ),
              40.verticalSpace,
              OtpTextField(
                fillColor: AppColors.whiteColor,
                filled: true,
                fieldWidth: 45.0.w,
                borderRadius: BorderRadius.circular(10.r),
                numberOfFields: 6,
                borderColor: AppColors.bordercolour,
                focusedBorderColor: AppColors.bordercolour,
                enabledBorderColor: AppColors.bordercolour,
                textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: AppColors.textfieldcolour,
                ),
                showFieldAsBox: true,

                onSubmit: (value) {
                  _submitOtp(value);
                },
              ),

              24.verticalSpace,
              Obx(() {
                return AppButton(
                  onPress: () async => _submitOtp(_enteredOtp),
                  horizontalMargin: 24.w,
                  text: "Verify",
                  buttonLoader: authController.isVerifyOtpLoading.value,
                  backgroundColor: AppColors.buttoncolour,
                );
              }),

              90.verticalSpace,
              Center(
                child: CircularCountDownTimer(
                  duration: 60,
                  initialDuration: 0,
                  width: 113.w,
                  height: 112.h,
                  ringColor: Color(0xffFE5B00),

                  fillColor: const Color(0xffFE5B00),
                  backgroundColor: Colors.transparent,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  textStyle: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: AppColors.textfieldcolour,
                  ),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isReverseAnimation: false,
                  isTimerTextShown: true,
                  autoStart: true,
                  onStart: () {},
                  onComplete: () {},
                  onChange: (String timeStamp) {
                    debugPrint('Countdown Changed $timeStamp');
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                styledText("Didn't Receive Code?", TextType.font14400),
                3.horizontalSpace,
                Obx(() {
                  return GestureDetector(
                    onTap:
                        authController.isResendOtpLoading.value
                            ? null
                            : authController.resendOtp,
                    child: styledText(
                      authController.isResendOtpLoading.value
                          ? "Resending..."
                          : "Resend Code",
                      TextType.font16600,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
