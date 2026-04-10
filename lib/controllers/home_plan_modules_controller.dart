import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/models/plan_level_preview_model.dart';
import 'package:tang_soo_karate/services/plans/plan_level_service.dart';

class HomePlanModulesController extends GetxController {
  HomePlanModulesController({PlanLevelService? planLevelService})
    : _service = planLevelService ?? PlanLevelService();

  /// Set to `false` when the API returns real `isLocked` values.
  static const bool ignoreServerLockForIntegration = true;

  final PlanLevelService _service;

  final selectedLevelIndex = 0.obs;
  final sections = <PlanLevelSection>[].obs;
  final planTitle = ''.obs;
  final totalLessons = 0.obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();

  int get planId => selectedLevelIndex.value + 1;

  String get headerTitle {
    final t = planTitle.value.trim();
    if (t.isNotEmpty) return t;
    return 'Level ${selectedLevelIndex.value + 1}';
  }

  /// Free-trial CTA for Level 1 “Foundations” style rows (matches prior UX).
  bool showFreeTrialFor(PlanLevelSection s) {
    if (selectedLevelIndex.value != 0) return false;
    if (s.beltId == 0) return true;
    final title = s.beltTitle.toLowerCase();
    return title.contains('foundation');
  }

  String dialogAmountForLevel(int levelIndex) {
    switch (levelIndex) {
      case 0:
        return '\$4.99';
      case 1:
        return '\$5.99';
      default:
        return '\$6.99';
    }
  }

  String levelLabelForIndex(int index) => 'Level ${index + 1}';

  /// Lock UI and purchase gate use this so integration can ignore stale `true` from API.
  bool isBeltLocked(PlanLevelSection s) =>
      ignoreServerLockForIntegration ? false : s.isLocked;

  @override
  void onInit() {
    super.onInit();
    loadPlanForSelectedLevel();
  }

  Future<void> loadPlanForSelectedLevel() async {
    final id = planId;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final data = await _service.fetchPlanLevelPreview(
        planId: id,
        context: Get.context,
      );
      if (data != null) {
        planTitle.value = data.planTitle;
        totalLessons.value = data.totalLessons;
        sections.assignAll(data.sections);
      } else {
        planTitle.value = '';
        totalLessons.value = 0;
        sections.clear();
      }
    } catch (e, st) {
      debugPrint('HomePlanModulesController.loadPlanForSelectedLevel: $e\n$st');
      errorMessage.value = e.toString();
      planTitle.value = '';
      totalLessons.value = 0;
      sections.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void onLevelTabTap(int index) {
    final changed = selectedLevelIndex.value != index;
    selectedLevelIndex.value = index;
    if (changed) {
      loadPlanForSelectedLevel();
      return;
    }
    if (sections.isEmpty || errorMessage.value != null) {
      loadPlanForSelectedLevel();
    }
  }

  Future<void> retry() => loadPlanForSelectedLevel();
}
