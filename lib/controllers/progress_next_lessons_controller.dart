import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/models/progress_next_lesson_model.dart';
import 'package:tang_soo_karate/services/progress/progress_next_lessons_service.dart';

class ProgressNextLessonsController extends GetxController {
  ProgressNextLessonsController({ProgressNextLessonsService? service})
    : _service = service ?? ProgressNextLessonsService();

  final ProgressNextLessonsService _service;

  final lessons = <ProgressNextLesson>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxnString();
  final hasNext = false.obs;

  /// Anchor from overview `CurrentLesson.id` for the first `/lessons/{id}/next` call.
  int? _overviewCurrentLessonId;

  /// Called when overview loads (or clears). Starts or clears the next-lesson queue.
  void syncFromCurrentLesson(int? currentLessonId) {
    debugPrint(
      '[ProgressNextLessons] syncFromCurrentLesson: overview CurrentLesson.id = '
      '${currentLessonId?.toString() ?? "null (no next fetch)"}',
    );
    _overviewCurrentLessonId = currentLessonId;
    load();
  }

  /// First page: `GET /lessons/{CurrentLesson.id}/next`.
  Future<void> load() async {
    final anchor = _overviewCurrentLessonId;
    if (anchor == null) {
      debugPrint(
        '[ProgressNextLessons] load: skipped — no anchor id (overview had no CurrentLesson)',
      );
      isLoading.value = false;
      isLoadingMore.value = false;
      errorMessage.value = null;
      lessons.clear();
      hasNext.value = false;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;
    try {
      debugPrint(
        '[ProgressNextLessons] load: GET /lessons/$anchor/next (first page from overview)',
      );
      final r = await _service.fetchNextAfterLesson(
        lessonId: anchor,
        context: Get.context,
      );
      lessons.assignAll(r.lessons);
      hasNext.value = _hasMoreFromResult(r);
    } catch (e, st) {
      debugPrint('ProgressNextLessonsController.load: $e\n$st');
      errorMessage.value = e.toString();
      lessons.clear();
      hasNext.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasMoreFromResult(NextLessonsPageResult r) {
    if (r.lessons.isEmpty) return false;
    final p = r.pagination;
    if (p != null) return p.hasNext;
    return true;
  }

  /// Chains `GET /lessons/{lastLoadedLessonId}/next` until empty or pagination says stop.
  Future<void> loadMore() async {
    if (!hasNext.value || isLoadingMore.value || isLoading.value) return;
    if (lessons.isEmpty) return;

    isLoadingMore.value = true;
    try {
      final chainId = lessons.last.id;
      debugPrint(
        '[ProgressNextLessons] loadMore: GET /lessons/$chainId/next '
        '(chain from last loaded lesson id)',
      );
      final r = await _service.fetchNextAfterLesson(
        lessonId: chainId,
        context: Get.context,
      );
      if (r.lessons.isEmpty) {
        hasNext.value = false;
        return;
      }
      final existing = lessons.map((e) => e.id).toSet();
      final toAdd = r.lessons.where((l) => !existing.contains(l.id)).toList();
      if (toAdd.isEmpty) {
        hasNext.value = false;
        return;
      }
      lessons.addAll(toAdd);
      hasNext.value = _hasMoreFromResult(r);
    } catch (e, st) {
      debugPrint('ProgressNextLessonsController.loadMore: $e\n$st');
      Get.snackbar(
        'Could not load more',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> retry() => load();
}
