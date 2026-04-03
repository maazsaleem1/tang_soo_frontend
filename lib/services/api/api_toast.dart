import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSuccessToast {
  AppSuccessToast({required this.title});

  final String title;

  void showToast(BuildContext? context) {
    // Do not require BuildContext — after await, Get.context is often null; Get.snackbar uses overlay.
    Get.snackbar(
      'Success',
      title,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}

class AppErrorToast {
  AppErrorToast({required this.title});

  final String title;

  void showToast(BuildContext? context) {
    Get.snackbar(
      'Error',
      title,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }
}
