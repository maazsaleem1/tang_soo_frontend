import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tang_soo_karate/authentication/sign_in_screen.dart';
import 'package:tang_soo_karate/authentication/reset_password_screen.dart';
import 'package:tang_soo_karate/authentication/verify_otp_screen.dart';
import 'package:tang_soo_karate/models/user_model.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/training_journey_screen.dart';
import 'package:tang_soo_karate/services/api/api_storage.dart';
import 'package:tang_soo_karate/services/auth/auth_service.dart';
import 'package:tang_soo_karate/utils/field_validator.dart';

import 'navbar_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  final rememberMe = false.obs;
  final isLoginLoading = false.obs;
  final isSignupLoading = false.obs;
  final isForgotPasswordLoading = false.obs;
  final isResetPasswordLoading = false.obs;

  final isLoginPasswordObscure = true.obs;
  final isSignupPasswordObscure = true.obs;
  final isSignupConfirmPasswordObscure = true.obs;
  final isVerifyOtpLoading = false.obs;
  final isResendOtpLoading = false.obs;
  final currentUser = Rxn<UserModel>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final forgotPasswordEmailController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final resetConfirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadStoredUser();
  }

  String? validateFirstName(String? value) {
    return validate(value ?? '', 'First Name');
  }

  String? validateLastName(String? value) {
    return validate(value ?? '', 'Last Name');
  }

  String? validateEmail(String? value) {
    return validate(value ?? '', 'Email');
  }

  String? validatePassword(String? value) {
    return validate(value ?? '', 'Password');
  }

  String? validateConfirmPassword(String? value) {
    return validate(
      value ?? '',
      'Confirm Password',
      password: passwordController.text,
    );
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void toggleLoginPasswordVisibility() {
    isLoginPasswordObscure.value = !isLoginPasswordObscure.value;
  }

  void toggleSignupPasswordVisibility() {
    isSignupPasswordObscure.value = !isSignupPasswordObscure.value;
  }

  void toggleSignupConfirmPasswordVisibility() {
    isSignupConfirmPasswordObscure.value =
        !isSignupConfirmPasswordObscure.value;
  }

  Future<void> signup() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(signupFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isSignupLoading.value = true;

      final response = await _authService.signup(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        context: Get.context,
      );

      if (response['success'] == true) {
        await loadStoredUser();
        clearSignupFields();
        Get.to(() => const VerifyOtpScreen(page: 'createaccount'));
      }
    } finally {
      isSignupLoading.value = false;
    }
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(loginFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isLoginLoading.value = true;

      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        context: Get.context,
      );

      if (response['success'] == true) {
        await loadStoredUser();
        final data = (response['data'] as Map?)?.cast<String, dynamic>();
        final user = (data?['user'] as Map?)?.cast<String, dynamic>();
        final isVerified = user?['isVerified'] == true;

        if (!isVerified) {
          Get.to(() => const VerifyOtpScreen(page: 'login'));
          return;
        }

        if (!Get.isRegistered<NavBarController>()) {
          Get.put(NavBarController());
        }
        if (!rememberMe.value) {
          clearLoginFields();
        }
        Get.find<NavBarController>().itemSelect(0);
        Get.offAll(() => NavBarScreen());
      }
    } finally {
      isLoginLoading.value = false;
    }
  }

  void clearLoginFields() {
    emailController.clear();
    passwordController.clear();
  }

  void clearSignupFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void clearResetPasswordFields() {
    oldPasswordController.clear();
    newPasswordController.clear();
    resetConfirmPasswordController.clear();
  }

  Future<bool> _verifyOtpRequest(String otp) async {
    if (otp.trim().length != 6) {
      Get.snackbar('Error', 'Please enter valid 6 digit OTP');
      return false;
    }

    try {
      isVerifyOtpLoading.value = true;
      final response = await _authService.verifyOtp(
        otp: otp.trim(),
        context: Get.context,
      );

      return response['success'] == true;
    } finally {
      isVerifyOtpLoading.value = false;
    }
  }

  Future<void> verifySignupOtp(String otp) async {
    final isSuccess = await _verifyOtpRequest(otp);
    if (isSuccess) {
      Get.offAll(() => const TrainingJourneyScreen());
    }
  }

  Future<void> verifyForgotPasswordOtp(String otp) async {
    final isSuccess = await _verifyOtpRequest(otp);
    if (isSuccess) {
      clearResetPasswordFields();
      Get.to(() => const ResetPasswordScreen());
    }
  }

  Future<void> resendOtp() async {
    if (isResendOtpLoading.value) return;

    try {
      isResendOtpLoading.value = true;
      await _authService.resendOtp(context: Get.context);
    } finally {
      isResendOtpLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isForgotPasswordLoading.value = true;
      final response = await _authService.forgotPassword(
        email: forgotPasswordEmailController.text.trim(),
        context: Get.context,
      );

      if (response['success'] == true) {
        forgotPasswordEmailController.clear();
        clearResetPasswordFields();
        Get.to(() => const VerifyOtpScreen(page: 'forgotpassword'));
      }
    } finally {
      isForgotPasswordLoading.value = false;
    }
  }

  Future<void> loadStoredUser() async {
    currentUser.value = await ApiStorage.getUser();
  }

  Future<void> resetPassword() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!(resetPasswordFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isResetPasswordLoading.value = true;
      final response = await _authService.resetPassword(
        oldPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        context: Get.context,
      );

      if (response['success'] == true) {
        clearResetPasswordFields();
        Get.offAll(() => const SignInScreen());
      }
    } finally {
      isResetPasswordLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    forgotPasswordEmailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    resetConfirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}

class Logincontroller extends AuthController {}
