import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/models/faq_item_model.dart';
import 'package:tang_soo_karate/services/faq/faq_service.dart';

class FaqController extends GetxController {
  FaqController({FaqService? faqService}) : _faqService = faqService ?? FaqService();

  final FaqService _faqService;

  final items = <FaqItemModel>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadFaqs();
  }

  Future<void> loadFaqs() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final list = await _faqService.fetchFaqs(context: Get.context);
      items.assignAll(list);
    } catch (e, st) {
      debugPrint('FaqController.loadFaqs: $e\n$st');
      errorMessage.value = e.toString();
      items.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
