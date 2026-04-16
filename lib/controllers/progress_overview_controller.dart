import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/progress_next_lessons_controller.dart';
import 'package:tang_soo_karate/models/progress_overview_model.dart';
import 'package:tang_soo_karate/services/progress/progress_overview_service.dart';

class ProgressOverviewController extends GetxController {
  ProgressOverviewController({ProgressOverviewService? service})
    : _service = service ?? ProgressOverviewService();

  final ProgressOverviewService _service;

  final overview = Rxn<ProgressOverviewData>();
  final isLoading = true.obs;
  final errorMessage = RxnString();

  String get currentLevelDisplay {
    final s = overview.value?.currentLevel.trim() ?? '';
    return s.isEmpty ? '—' : s;
  }

  String get currentLessonTitleLine {
    final lesson = overview.value?.currentLesson;
    if (lesson == null || lesson.title.trim().isEmpty) {
      return 'No lesson in progress';
    }
    return '${lesson.order}. ${lesson.title}';
  }

  int get completedCount => overview.value?.completedLesson ?? 0;

  int get totalCount => overview.value?.totalLessons ?? 0;

  int get percentClamped =>
      (overview.value?.overallPercentage ?? 0).clamp(0, 100);

  double get progressFraction => overview.value?.overallFraction ?? 0;

  String get percentLabel =>
      percentClamped.toString().padLeft(2, '0');

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final data = await _service.fetchOverview(context: Get.context);
      overview.value = data;

      if (Get.isRegistered<ProgressNextLessonsController>()) {
        final cur = data?.currentLesson;
        final nextAnchor =
            (cur != null && cur.id > 0) ? cur.id : null;
        debugPrint(
          '[ProgressOverview] overview loaded — passing CurrentLesson.id to '
          'next-lessons anchor: ${nextAnchor?.toString() ?? "null (skip /lessons/{id}/next)"}',
        );
        Get.find<ProgressNextLessonsController>().syncFromCurrentLesson(
          nextAnchor,
        );
      }
    } catch (e, st) {
      debugPrint('ProgressOverviewController.load: $e\n$st');
      errorMessage.value = e.toString();
      overview.value = null;
      if (Get.isRegistered<ProgressNextLessonsController>()) {
        Get.find<ProgressNextLessonsController>().syncFromCurrentLesson(null);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() => load();
}
