import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tang_soo_karate/controllers/contact_support_controller.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  late final ContactSupportController _c;

  @override
  void initState() {
    super.initState();
    _c = Get.put(ContactSupportController());
  }

  @override
  void dispose() {
    Get.delete<ContactSupportController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: 'Contact Support',
        textType: TextType.font16600,
        showBack: true,
        onPress: Get.back,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 20.h),
        child: Form(
          key: _c.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInput(
                placeHolder: 'Jon',
                label: 'Name',
                controller: _c.nameController,
                validator: _c.validateName,
                horizontalMargin: 0,
                bottomMargin: 12,
                verticalPadding: 12,
                borderradius: 100,
                enabledborderradius: 100,
                errorborderradius: 100,
                focusedErrorBorder: 100,
                borderColor: const Color(0xFFE9E9E9),
              ),
              AppInput(
                placeHolder: 'tangsookarateapp@gmail.com',
                label: 'Email',
                controller: _c.emailController,
                validator: _c.validateEmail,
                horizontalMargin: 0,
                bottomMargin: 12,
                verticalPadding: 12,
                borderradius: 100,
                enabledborderradius: 100,
                errorborderradius: 100,
                focusedErrorBorder: 100,
                borderColor: const Color(0xFFE9E9E9),
              ),
              _fieldLabel('Select Subject'),
              6.verticalSpace,
              _SubjectDropdown(controller: _c),
              12.verticalSpace,
              AppInput(
                placeHolder: 'Description..',
                label: 'Message',
                controller: _c.messageController,
                validator: _c.validateMessage,
                horizontalMargin: 0,
                bottomMargin: 14,
                verticalPadding: 10,
                maxLines: 4,
                maxLenght: 300,
                borderradius: 12,
                enabledborderradius: 12,
                errorborderradius: 12,
                focusedErrorBorder: 12,
                borderColor: const Color(0xFFE9E9E9),
              ),
              Obx(
                () => AppButton(
                  onPress: _c.submit,
                  text: 'Send Message',
                  buttonLoader: _c.isSubmitting.value,
                  backgroundColor: AppColors.buttoncolour,
                  horizontalMargin: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return styledText(text, TextType.font16500);
  }
}

class _SubjectDropdown extends StatelessWidget {
  const _SubjectDropdown({required this.controller});

  final ContactSupportController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final open = controller.isDropdownOpen.value;
      final selected = controller.selectedSubject.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: const Color(0xFFE9E9E9)),
        ),
        child: Column(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(18.r),
              onTap: controller.toggleSubjectDropdown,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: AppColors.appbarTitleColor,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.hintstylecolour,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xFFE9E9E9))),
                ),
                child: Column(
                  children:
                      ContactSupportController.subjects
                          .map(
                            (subject) => InkWell(
                              onTap: () => controller.selectSubject(subject),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20.w,
                                  vertical: 10.h,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        subject,
                                        style: GoogleFonts.inter(
                                          fontWeight:
                                              selected == subject
                                                  ? FontWeight.w500
                                                  : FontWeight.w400,
                                          fontSize:
                                              selected == subject
                                                  ? 14.sp
                                                  : 13.sp,
                                          color:
                                              selected == subject
                                                  ? AppColors.appbarTitleColor
                                                  : AppColors.hintstylecolour,
                                        ),
                                      ),
                                    ),
                                    if (selected == subject)
                                      const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Color(0xFF01708A),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
              crossFadeState:
                  open ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 220),
            ),
          ],
        ),
      );
    });
  }
}
