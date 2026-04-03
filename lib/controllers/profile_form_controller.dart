import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tang_soo_karate/controllers/auth_controllers.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/on_boarding_screens.dart/introduction_video_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';


enum ProfileFormMode { create, edit }

class ProfileFormController extends GetxController {
  ProfileFormController({required this.mode});

  final ProfileFormMode mode;

  static const Color profileTeal = Color(0xFF007A8B);
  static const double pillRadius = 100.0;
  static const Color fieldBorder = Color(0xFFE5E5E5);

  late final AuthController _auth;

  final fullNameController = TextEditingController();
  final dobController = TextEditingController();
  final mobileController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final zipController = TextEditingController();
  final danController = TextEditingController();

  final birthDate = DateTime(2000, 1, 1).obs;
  final profileImageFile = Rxn<File>();
  final submitting = false.obs;

  final ImagePicker _picker = ImagePicker();

  String? get networkAvatarUrl {
    if (mode != ProfileFormMode.edit) return null;
    final u = _auth.currentUser.value;
    return ApiConfig.absoluteMediaUrl(u?.profileImageUrl);
  }

  @override
  void onInit() {
    super.onInit();
    _auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController(), permanent: true);
    if (mode == ProfileFormMode.create) {
      _initCreate();
    } else {
      _initEdit();
    }
  }

  void _initCreate() {
    final fn = _auth.firstNameController.text.trim();
    final ln = _auth.lastNameController.text.trim();
    if (fn.isNotEmpty || ln.isNotEmpty) {
      fullNameController.text = '$fn $ln'.trim();
    }
    final u = _auth.currentUser.value;
    if (u != null) {
      if (fullNameController.text.isEmpty && u.fullName.isNotEmpty) {
        fullNameController.text = u.fullName;
      }
      if (u.mobile.isNotEmpty) mobileController.text = u.mobile;
      if (u.address.isNotEmpty) {
        _applyAddressParts(u.address, streetController, cityController);
      }
      if (u.country.isNotEmpty) countryController.text = u.country;
      if (u.postalCode.isNotEmpty) zipController.text = u.postalCode;
      final parsed = _tryParseApiDob(u.dob);
      if (parsed != null) {
        birthDate.value = parsed;
        dobController.text = formatDob(parsed);
      }
    }
  }

  void _initEdit() {
    final u = _auth.currentUser.value;
    if (u == null) return;
    if (u.fullName.isNotEmpty) fullNameController.text = u.fullName;
    if (u.mobile.isNotEmpty) mobileController.text = u.mobile;
    if (u.country.isNotEmpty) countryController.text = u.country;
    if (u.postalCode.isNotEmpty) zipController.text = u.postalCode;
    _applyAddressParts(u.address, streetController, cityController);
    final parsed = _tryParseApiDob(u.dob);
    if (parsed != null) {
      birthDate.value = parsed;
      dobController.text = formatDob(parsed);
    }
    danController.text = u.preferences['danNumber']?.toString() ?? '';
  }

  static String formatDob(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return '$dd / $mm / $yyyy';
  }

  static DateTime? _tryParseApiDob(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  static void _applyAddressParts(
    String address,
    TextEditingController street,
    TextEditingController city,
  ) {
    final trimmed = address.trim();
    if (trimmed.isEmpty) return;
    final idx = trimmed.indexOf(',');
    if (idx >= 0) {
      street.text = trimmed.substring(0, idx).trim();
      city.text = trimmed.substring(idx + 1).trim();
    } else {
      street.text = trimmed;
    }
  }

  Future<void> pickProfileImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
    if (source == null) return;

    try {
      final x = await _picker.pickImage(source: source, imageQuality: 85);
      if (x != null) {
        profileImageFile.value = File(x.path);
      }
    } on PlatformException catch (e) {
      Get.snackbar(
        'Photo',
        e.message ??
            'Could not open the image picker. Stop the app, run a full rebuild '
                '(not hot reload), and allow photo/camera access.',
      );
    }
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: profileTeal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.appbarTitleColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      birthDate.value = picked;
      dobController.text = formatDob(picked);
    }
  }

  bool _validate() {
    if (fullNameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter your full name');
      return false;
    }
    if (dobController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please select your date of birth');
      return false;
    }
    return true;
  }

  Future<void> submit() async {
    if (submitting.value) return;
    if (!_validate()) return;

    submitting.value = true;
    try {
      final ok = await _auth.submitCreateProfile(
        fullName: fullNameController.text,
        birthDate: birthDate.value,
        mobile: mobileController.text,
        street: streetController.text,
        city: cityController.text,
        country: countryController.text,
        zip: zipController.text,
        profileImage: profileImageFile.value,
      );
      if (!ok) return;

      if (mode == ProfileFormMode.create) {
        _auth.clearSignupFields();
        Get.off(() => const IntroductionScreen());
        return;
      }

      // Do not use closeOverlays: true — it dismisses Get.snackbar overlays, so the
      // success toast from [patchMultiPartApi]/returnResponse would vanish instantly.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.back(closeOverlays: false);
      });
    } finally {
      submitting.value = false;
    }
  }

  Future<void> showLeaveCreateProfileDialog(BuildContext context) async {
    const signOutRed = Color(0xFFC62828);
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Container(
            padding: EdgeInsets.fromLTRB(22.w, 26.h, 22.w, 22.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                styledText(
                  'Leave profile setup?',
                  TextType.font20700,
                  color: AppColors.appbarTitleColor,
                ),
                14.verticalSpace,
                Text(
                  'Your profile is not complete yet. If you go back now, you '
                  'will be signed out and will need to sign in again to continue.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightcolourfortext,
                  ),
                ),
                26.verticalSpace,
                AppButton(
                  text: 'Stay',
                  minWidth: 0,
                  height: 50,
                  verticalMargin: 0,
                  backgroundColor: profileTeal,
                  textColor: Colors.white,
                  onPress: () => Navigator.of(ctx).pop(),
                ),
                12.verticalSpace,
                AppButton(
                  text: 'Sign out',
                  minWidth: 0,
                  height: 50,
                  verticalMargin: 0,
                  backgroundColor: AppColors.whiteColor,
                  textColor: signOutRed,
                  borderColor: signOutRed,
                  onPress: () async {
                    Navigator.of(ctx).pop();
                    await _auth.abandonCreateProfileAndSignOut();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onClose() {
    fullNameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    streetController.dispose();
    cityController.dispose();
    countryController.dispose();
    zipController.dispose();
    danController.dispose();
    super.onClose();
  }
}
