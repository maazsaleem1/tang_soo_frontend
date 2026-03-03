import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSuccessToast {
  AppSuccessToast({required this.title});

  final String title;

  void showToast(BuildContext? context) {
    final target = context ?? Get.context;
    if (target == null) return;

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
    final target = context ?? Get.context;
    if (target == null) return;

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
