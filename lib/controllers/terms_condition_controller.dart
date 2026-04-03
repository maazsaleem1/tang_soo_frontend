import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/models/cms_page_model.dart';
import 'package:tang_soo_karate/services/pages/cms_pages_service.dart';

/// Loads Terms & Conditions from GET `/pages/term`.
class TermsConditionController extends GetxController {
  TermsConditionController({CmsPagesService? pagesService})
      : _pagesService = pagesService ?? CmsPagesService();

  final CmsPagesService _pagesService;

  static const String termsSlug = 'term';

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
        slug: termsSlug,
        context: Get.context,
      );
      page.value = p;
    } catch (e, st) {
      debugPrint('TermsConditionController.load: $e\n$st');
      errorMessage.value = e.toString();
      page.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
