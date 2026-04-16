import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tang_soo_karate/controllers/training_progress_controller.dart';
import 'package:tang_soo_karate/models/belt_lessons_model.dart';
import 'package:tang_soo_karate/services/api/api_toast.dart';
import 'package:tang_soo_karate/services/lessons/belt_lessons_service.dart';
import 'package:tang_soo_karate/services/lessons/lesson_progress_service.dart';

class BeltLessonsController extends GetxController {
  BeltLessonsController({
    required this.beltId,
    required String initialBeltTitle,
    BeltLessonsService? service,
    LessonProgressService? progressService,
  }) : _service = service ?? BeltLessonsService(),
       _progressService = progressService ?? LessonProgressService() {
    final t = initialBeltTitle.trim();
    beltName.value = t.isEmpty ? 'Lessons' : t;
  }

  final int beltId;
  final BeltLessonsService _service;
  final LessonProgressService _progressService;

  final beltName = ''.obs;
  final lessons = <BeltLesson>[].obs;
  final isLoading = true.obs;
  final isSubmittingComplete = false.obs;
  final isSubmittingBookmark = false.obs;
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

  /// [silent] avoids full-screen shimmer (e.g. after marking a lesson complete).
  Future<void> load({bool silent = false}) async {
    if (!silent) {
      isLoading.value = true;
      errorMessage.value = null;
    }
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
      errorMessage.value = null;
    } catch (e, st) {
      debugPrint('BeltLessonsController.load: $e\n$st');
      if (silent) rethrow;
      errorMessage.value = e.toString();
      lessons.clear();
    } finally {
      if (!silent) isLoading.value = false;
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

  /// POST `bookmarked`, refresh belt lessons from API. Returns true on success.
  Future<bool> submitBookmark(BeltLesson l, BuildContext? context) async {
    if (isBookmarked(l)) return false;
    isSubmittingBookmark.value = true;
    try {
      await _progressService.markLessonBookmarked(
        lessonId: l.id,
        context: context ?? Get.context,
      );
      await load(silent: true);
      bookmarkRev.value++;
      return true;
    } catch (e, st) {
      debugPrint('BeltLessonsController.submitBookmark: $e\n$st');
      final msg =
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : e.toString();
      AppErrorToast(title: msg).showToast(Get.context);
      return false;
    } finally {
      isSubmittingBookmark.value = false;
    }
  }

  /// POST progress, then GET belt lessons so `isCompleted` / percent come from API.
  Future<bool> markComplete(BeltLesson l, BuildContext? context) async {
    if (isCompleted(l)) return false;
    isSubmittingComplete.value = true;
    try {
      await _progressService.markLessonCompleted(
        lessonId: l.id,
        context: context ?? Get.context,
      );
      await load(silent: true);
      TrainingProgressController.ensureRegistered();
      final idx = lessons.indexWhere((x) => x.id == l.id);
      Get.find<TrainingProgressController>().completeLevelOneLesson(
        idx < 0 ? 0 : idx,
        l.title,
      );
      return true;
    } catch (e, st) {
      debugPrint('BeltLessonsController.markComplete: $e\n$st');
      final msg =
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : e.toString();
      AppErrorToast(title: msg).showToast(Get.context);
      return false;
    } finally {
      isSubmittingComplete.value = false;
    }
  }

  Future<void> retry() => load();
}
