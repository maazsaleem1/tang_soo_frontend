import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/app_button.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_appbar.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_status_dialog.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_field.dart';
import 'package:tang_soo_karate/custom_widgets.dart/text_font_wise.dart';
import 'package:tang_soo_karate/profile_setting_folder/help_support_screen.dart';
import 'package:tang_soo_karate/res/app_colours.dart';

class ContactSupportScreen extends StatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  State<ContactSupportScreen> createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "Jon",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "tangsookarateapp@gmail.com",
  );
  final TextEditingController _messageController = TextEditingController();

  final List<String> _subjects = const [
    "payment issue",
    "account issue",
    "technical issue",
    "other",
  ];
  String _selectedSubject = "payment issue";
  bool _isDropdownOpen = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundcolour,
      appBar: CustomAppBar(
        title: "Contact Support",
        textType: TextType.font16600,
        showBack: true,
        onPress: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(12.w, 14.h, 12.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppInput(
              placeHolder: "Jon",
              label: "Name",
              controller: _nameController,
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
              placeHolder: "tangsookarateapp@gmail.com",
              label: "Email",
              controller: _emailController,
              horizontalMargin: 0,
              bottomMargin: 12,
              verticalPadding: 12,
              borderradius: 100,
              enabledborderradius: 100,
              errorborderradius: 100,
              focusedErrorBorder: 100,
              borderColor: const Color(0xFFE9E9E9),
            ),
            _fieldLabel("Select Subject"),
            6.verticalSpace,
            _subjectDropdown(),
            12.verticalSpace,
            AppInput(
              placeHolder: "Description..",
              label: "Message",
              controller: _messageController,
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
            AppButton(
              onPress: () {
                showCustomStatusDialog(
                  context: context,
                  message: "Your Message Has\nBeen Sent",
                  iconPath: "assets/images/tickicon.svg",
                );

                Future.delayed(const Duration(seconds: 2), () {
                  if (!mounted) return;
                  if (Get.isDialogOpen ?? false) {
                    Get.back();
                  }
                  Get.close(2);
                });
              },
              text: "Send Message",
              backgroundColor: AppColors.buttoncolour,
              horizontalMargin: 0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return styledText(text, TextType.font10, color: const Color(0xFF9B9B9B));
  }

  Widget _subjectDropdown() {
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
            onTap: () {
              setState(() {
                _isDropdownOpen = !_isDropdownOpen;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedSubject,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isDropdownOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF8F8F8F),
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
                    _subjects
                        .map(
                          (subject) => InkWell(
                            onTap: () {
                              setState(() {
                                _selectedSubject = subject;
                                _isDropdownOpen = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      subject,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF555555),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  if (_selectedSubject == subject)
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
                _isDropdownOpen
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}
