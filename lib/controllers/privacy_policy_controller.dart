import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/models/cms_page_model.dart';
import 'package:tang_soo_karate/services/pages/cms_pages_service.dart';

/// Loads Privacy Policy from GET `/pages/privacy`.
class PrivacyPolicyController extends GetxController {
  PrivacyPolicyController({CmsPagesService? pagesService})
      : _pagesService = pagesService ?? CmsPagesService();

  final CmsPagesService _pagesService;

  static const String privacySlug = 'privacy';

  final isLoading = true.obs;
  final errorMessage = RxnString();
  final page = Rxn<CmsPageModel>();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final p = await _pagesService.fetchPage(
        slug: privacySlug,
        context: Get.context,
      );
      page.value = p;
    } catch (e, st) {
      debugPrint('PrivacyPolicyController.load: $e\n$st');
      errorMessage.value = e.toString();
      page.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
