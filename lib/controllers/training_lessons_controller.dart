import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/models/user_training_lesson_model.dart';
import 'package:tang_soo_karate/services/lessons/user_training_lessons_service.dart';

class TrainingLessonsController extends GetxController {
  TrainingLessonsController({
    this.initialTabIndex = 0,
    UserTrainingLessonsService? service,
  }) : _service = service ?? UserTrainingLessonsService();

  final UserTrainingLessonsService _service;
  final int initialTabIndex;

  static const _filterKeys = ['all', 'isCompleted', 'isBookmarked'];
  static const _pageSize = 10;

  final selectedTab = 0.obs;
  final lessons = <UserTrainingLesson>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = RxnString();
  final hasNextPage = false.obs;

  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    selectedTab.value = initialTabIndex.clamp(0, 2);
    load(reset: true);
  }

  String get _filterKey => _filterKeys[selectedTab.value.clamp(0, 2)];

  void selectTab(int index) {
    final i = index.clamp(0, 2);
    if (selectedTab.value == i) return;
    selectedTab.value = i;
    load(reset: true);
  }

  Future<void> load({bool reset = false}) async {
    if (reset) {
      _page = 1;
      lessons.clear();
      hasNextPage.value = false;
    }
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final r = await _service.fetchPage(
        filterKey: _filterKey,
        page: _page,
        limit: _pageSize,
        context: Get.context,
      );
      lessons.assignAll(r.lessons);
      hasNextPage.value = r.pagination?.hasNext ?? false;
    } catch (e, st) {
      debugPrint('TrainingLessonsController.load: $e\n$st');
      errorMessage.value = e.toString();
      lessons.clear();
      hasNextPage.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasNextPage.value || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    try {
      final nextPage = _page + 1;
      final r = await _service.fetchPage(
        filterKey: _filterKey,
        page: nextPage,
        limit: _pageSize,
        context: Get.context,
      );
      final existing = lessons.map((e) => e.id).toSet();
      final toAdd =
          r.lessons.where((l) => !existing.contains(l.id)).toList();
      if (toAdd.isEmpty) {
        hasNextPage.value = r.pagination?.hasNext ?? false;
        if (hasNextPage.value) {
          _page = nextPage;
        } else {
          hasNextPage.value = false;
        }
        return;
      }
      lessons.addAll(toAdd);
      _page = nextPage;
      hasNextPage.value = r.pagination?.hasNext ?? false;
    } catch (e, st) {
      debugPrint('TrainingLessonsController.loadMore: $e\n$st');
      Get.snackbar(
        'Could not load more',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> retry() => load(reset: true);
}
