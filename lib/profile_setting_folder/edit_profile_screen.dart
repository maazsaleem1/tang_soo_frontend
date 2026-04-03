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

const String _kEditProfileTag = 'edit_profile';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(
      ProfileFormController(mode: ProfileFormMode.edit),
      tag: _kEditProfileTag,
    );
  }

  @override
  void dispose() {
    Get.delete<ProfileFormController>(tag: _kEditProfileTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileFormController>(tag: _kEditProfileTag);

    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundcolour,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Get.back(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SvgPicture.asset(SvgIcons.backicon, fit: BoxFit.scaleDown),
          ),
        ),
        title: const SizedBox.shrink(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: styledText(
                'Edit Profile',
                TextType.font16400,
                color: AppColors.appbarTitleColor,
              ),
            ),
          ),
        ],
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
              _EditProfilePhotoRow(controller: c),
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
              _EditDateOfBirthField(controller: c),
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
                label: 'Dan Number',
                placeHolder: '—',
                controller: c.danController,
                readonly: true,
                enabled: false,
                backColor: const Color(0xFFE8E8E8),
                borderColor: ProfileFormController.fieldBorder,
                borderradius: ProfileFormController.pillRadius,
                enabledborderradius: ProfileFormController.pillRadius,
                errorborderradius: ProfileFormController.pillRadius,
                focusedErrorBorder: ProfileFormController.pillRadius,
                bottomMargin: 16,
                postfixIcon: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Icon(
                    Icons.lock_rounded,
                    size: 18.sp,
                    color: const Color(0xFFF7A600),
                  ),
                ),
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
                  text: 'Save Personal Information',
                  backgroundColor: ProfileFormController.profileTeal,
                  onPress: c.submit,
                  buttonLoader: c.submitting.value,
                ),
              ),
              14.verticalSpace,
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: styledText(
                    'Cancel',
                    TextType.font16500,
                    color: const Color(0xFF8A8A8A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditProfilePhotoRow extends StatelessWidget {
  const _EditProfilePhotoRow({required this.controller});

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
              child: _buildAvatarChild(),
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

  Widget _buildAvatarChild() {
    final file = controller.profileImageFile.value;
    if (file != null) {
      return Image.file(file, fit: BoxFit.cover);
    }
    final url = controller.networkAvatarUrl;
    if (url != null) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => Icon(
              Icons.image_outlined,
              size: 40.sp,
              color: const Color(0xFFB0B0B0),
            ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: ProfileFormController.profileTeal,
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            ),
          );
        },
      );
    }
    return Icon(
      Icons.image_outlined,
      size: 40.sp,
      color: const Color(0xFFB0B0B0),
    );
  }
}

class _EditDateOfBirthField extends StatelessWidget {
  const _EditDateOfBirthField({required this.controller});

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
