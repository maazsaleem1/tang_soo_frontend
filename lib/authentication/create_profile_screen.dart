import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/profile_form_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';
import 'package:tang_soo_karate/res/svgsicon.dart';

const String _kCreateProfileTag = 'create_profile';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(
      ProfileFormController(mode: ProfileFormMode.create),
      tag: _kCreateProfileTag,
    );
  }

  @override
  void dispose() {
    Get.delete<ProfileFormController>(tag: _kCreateProfileTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileFormController>(tag: _kCreateProfileTag);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        c.showLeaveCreateProfileDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundcolour,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.backgroundcolour,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          leading: GestureDetector(
            onTap: () => c.showLeaveCreateProfileDialog(context),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: SvgPicture.asset(SvgIcons.backicon, fit: BoxFit.scaleDown),
            ),
          ),
          title: styledText(
            'Create Profile',
            TextType.font16400,
            color: AppColors.appbarTitleColor,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                styledText(
                  'Personal Information',
                  TextType.font20700,
                  color: AppColors.appbarTitleColor,
                ),
                18.verticalSpace,
                styledText(
                  'Profile Photo',
                  TextType.font16400,
                  color: AppColors.appbarTitleColor,
                ),
                10.verticalSpace,
                _ProfilePhotoRow(controller: c),
                22.verticalSpace,
                AppInput(
                  label: 'Full Name',
                  placeHolder: 'Full Name',
                  controller: c.fullNameController,
                  borderColor: ProfileFormController.fieldBorder,
                  borderradius: ProfileFormController.pillRadius,
                  enabledborderradius: ProfileFormController.pillRadius,
                  errorborderradius: ProfileFormController.pillRadius,
                  focusedErrorBorder: ProfileFormController.pillRadius,
                  bottomMargin: 16,
                ),
                _DateOfBirthField(controller: c),
                AppInput(
                  label: 'Mobile Number',
                  placeHolder: '0 123 456 789',
                  controller: c.mobileController,
                  keyboardType: TextInputType.phone,
                  borderColor: ProfileFormController.fieldBorder,
                  borderradius: ProfileFormController.pillRadius,
                  enabledborderradius: ProfileFormController.pillRadius,
                  errorborderradius: ProfileFormController.pillRadius,
                  focusedErrorBorder: ProfileFormController.pillRadius,
                  bottomMargin: 16,
                ),
                AppInput(
                  label: 'Street Address',
                  placeHolder: 'Your address',
                  controller: c.streetController,
                  borderColor: ProfileFormController.fieldBorder,
                  borderradius: ProfileFormController.pillRadius,
                  enabledborderradius: ProfileFormController.pillRadius,
                  errorborderradius: ProfileFormController.pillRadius,
                  focusedErrorBorder: ProfileFormController.pillRadius,
                  bottomMargin: 16,
                ),
                AppInput(
                  label: 'City',
                  placeHolder: 'City',
                  controller: c.cityController,
                  borderColor: ProfileFormController.fieldBorder,
                  borderradius: ProfileFormController.pillRadius,
                  enabledborderradius: ProfileFormController.pillRadius,
                  errorborderradius: ProfileFormController.pillRadius,
                  focusedErrorBorder: ProfileFormController.pillRadius,
                  bottomMargin: 16,
                ),
                AppInput(
                  label: 'Country',
                  placeHolder: 'e.g. USA',
                  controller: c.countryController,
                  borderColor: ProfileFormController.fieldBorder,
                  borderradius: ProfileFormController.pillRadius,
                  enabledborderradius: ProfileFormController.pillRadius,
                  errorborderradius: ProfileFormController.pillRadius,
                  focusedErrorBorder: ProfileFormController.pillRadius,
                  bottomMargin: 16,
                ),
                AppInput(
                  label: 'ZIP Code',
                  placeHolder: 'ZIP Code',
                  controller: c.zipController,
                  keyboardType: TextInputType.number,
                  borderColor: ProfileFormController.fieldBorder,
                  borderradius: ProfileFormController.pillRadius,
                  enabledborderradius: ProfileFormController.pillRadius,
                  errorborderradius: ProfileFormController.pillRadius,
                  focusedErrorBorder: ProfileFormController.pillRadius,
                  bottomMargin: 20,
                ),
                Obx(
                  () => AppButton(
                    text: 'Continue',
                    backgroundColor: ProfileFormController.profileTeal,
                    onPress: c.submit,
                    buttonLoader: c.submitting.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePhotoRow extends StatelessWidget {
  const _ProfilePhotoRow({required this.controller});

  final ProfileFormController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.pickProfileImage(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(
            () => Container(
              width: 92.w,
              height: 92.w,
              decoration: const BoxDecoration(
                color: Color(0xFFEDEDED),
                shape: BoxShape.circle,
              ),
              clipBehavior: Clip.antiAlias,
              child: controller.profileImageFile.value != null
                  ? Image.file(
                      controller.profileImageFile.value!,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Icons.image_outlined,
                      size: 40.sp,
                      color: const Color(0xFFB0B0B0),
                    ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: GestureDetector(
              onTap: () => controller.pickProfileImage(context),
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E4C9F),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 10.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateOfBirthField extends StatelessWidget {
  const _DateOfBirthField({required this.controller});

  final ProfileFormController controller;

  @override
  Widget build(BuildContext context) {
    final r = ProfileFormController.pillRadius;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          styledText('Date of Birth', TextType.font16500),
          8.verticalSpace,
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => controller.pickDateOfBirth(context),
              borderRadius: BorderRadius.circular(r.r),
              child: TextFormField(
                controller: controller.dobController,
                readOnly: true,
                onTap: () => controller.pickDateOfBirth(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.appbarTitleColor,
                ),
                decoration: InputDecoration(
                  hintText: 'DD / MM / YYYY',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.hintstylecolour,
                  ),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 14.h,
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today_rounded,
                    size: 20.sp,
                    color: ProfileFormController.profileTeal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(r.r),
                    borderSide: const BorderSide(
                      color: ProfileFormController.fieldBorder,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(r.r),
                    borderSide: const BorderSide(
                      color: ProfileFormController.fieldBorder,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(r.r),
                    borderSide: const BorderSide(
                      color: ProfileFormController.fieldBorder,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
