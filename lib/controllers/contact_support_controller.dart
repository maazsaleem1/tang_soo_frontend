import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/custom_widgets.dart/custom_status_dialog.dart';
import 'package:tang_soo_karate/navbarfolder/navbar_screen.dart';
import 'package:tang_soo_karate/profile_setting_folder/help_support_screen.dart';
import 'package:tang_soo_karate/services/api/api_toast.dart';
import 'package:tang_soo_karate/services/support/contact_support_service.dart';
import 'package:tang_soo_karate/utils/field_validator.dart';

class ContactSupportController extends GetxController {
  ContactSupportController({ContactSupportService? supportService})
    : _service = supportService ?? ContactSupportService();

  final ContactSupportService _service;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  static const List<String> subjects = [
    'payment issue',
    'account issue',
    'technical issue',
    'other',
  ];

  final selectedSubject = 'payment issue'.obs;
  final isDropdownOpen = false.obs;
  final isSubmitting = false.obs;

  String? validateName(String? v) => validate(v ?? '', 'Name');

  String? validateEmail(String? v) => validate(v ?? '', 'Email');

  String? validateMessage(String? v) => validate(v ?? '', 'Message');

  void toggleSubjectDropdown() {
    isDropdownOpen.value = !isDropdownOpen.value;
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;
    isDropdownOpen.value = false;
  }

  Future<void> submit() async {
    if (isSubmitting.value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    isSubmitting.value = true;
    try {
      final result = await _service.submit(
        name: nameController.text,
        email: emailController.text,
        subject: selectedSubject.value,
        message: messageController.text,
        context: Get.context,
      );

      if (!result.success) {
        AppErrorToast(title: result.message).showToast(Get.context);
        return;
      }

      nameController.clear();
      emailController.clear();
      messageController.clear();
      formKey.currentState?.reset();

      final dialogText =
          result.message.trim().isEmpty
              ? 'Your Message Has\nBeen Sent'
              : result.message.trim();

      final dialogContext = Get.context;
      if (dialogContext != null && dialogContext.mounted) {
        isSubmitting.value = false;

        showCustomStatusDialog(
          context: dialogContext,
          message: dialogText,
          iconPath: 'assets/images/tickicon.svg',
        );
      }

      await Future<void>.delayed(const Duration(milliseconds: 1500));

      if (Get.isDialogOpen ?? false) {
        Get.close(1);
      }
      Get.offAll(() => const NavBarScreen(initialIndex: 3));
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
