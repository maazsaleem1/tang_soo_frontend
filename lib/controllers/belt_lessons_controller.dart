import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/training_progress_controller.dart';
import 'package:tang_soo_karate/models/belt_lessons_model.dart';
import 'package:tang_soo_karate/services/lessons/belt_lessons_service.dart';

class BeltLessonsController extends GetxController {
  BeltLessonsController({
    required this.beltId,
    required String initialBeltTitle,
    BeltLessonsService? service,
  }) : _service = service ?? BeltLessonsService() {
    final t = initialBeltTitle.trim();
    beltName.value = t.isEmpty ? 'Lessons' : t;
  }

  final int beltId;
  final BeltLessonsService _service;

  final beltName = ''.obs;
  final lessons = <BeltLesson>[].obs;
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final searchQuery = ''.obs;
  final selectedLessonId = Rxn<int>();
  final completedRev = 0.obs;
  final bookmarkRev = 0.obs;
  final Set<int> _extraCompletedIds = {};
  final Map<int, bool> _bookmarkOverride = {};

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final group = await _service.fetchBeltLessons(
        beltId: beltId,
        context: Get.context,
      );
      if (group != null) {
        _extraCompletedIds.clear();
        _bookmarkOverride.clear();
        completedRev.value++;
        bookmarkRev.value++;
        final name = group.beltName.trim();
        if (name.isNotEmpty) beltName.value = name;
        lessons.assignAll(group.lessons);
      } else {
        lessons.clear();
      }
    } catch (e, st) {
      debugPrint('BeltLessonsController.load: $e\n$st');
      errorMessage.value = e.toString();
      lessons.clear();
    } finally {
      isLoading.value = false;
    }
  }

  List<BeltLesson> get filteredLessons {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return List<BeltLesson>.from(lessons);
    return lessons.where((l) => l.title.toLowerCase().contains(q)).toList();
  }

  BeltLesson? lessonById(int id) {
    for (final l in lessons) {
      if (l.id == id) return l;
    }
    return null;
  }

  bool isCompleted(BeltLesson l) =>
      l.isCompleted || _extraCompletedIds.contains(l.id);

  bool isBookmarked(BeltLesson l) {
    final o = _bookmarkOverride[l.id];
    if (o != null) return o;
    return l.isBookmarked;
  }

  void setSearch(String value) => searchQuery.value = value;

  void openLesson(BeltLesson l) {
    if (l.isLocked) return;
    selectedLessonId.value = l.id;
  }

  void closeDetail() => selectedLessonId.value = null;

  void toggleBookmark(int lessonId) {
    final l = lessonById(lessonId);
    if (l == null) return;
    _bookmarkOverride[lessonId] = !isBookmarked(l);
    bookmarkRev.value++;
  }

  void markComplete(BeltLesson l) {
    if (isCompleted(l)) return;
    _extraCompletedIds.add(l.id);
    completedRev.value++;
    TrainingProgressController.ensureRegistered();
    final idx = lessons.indexWhere((x) => x.id == l.id);
    Get.find<TrainingProgressController>().completeLevelOneLesson(
      idx < 0 ? 0 : idx,
      l.title,
    );
  }

  Future<void> retry() => load();
}
