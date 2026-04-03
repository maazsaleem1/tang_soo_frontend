import 'package:get/get.dart';

/// Syncs Level 1 completions with the Training tab lesson list.
class TrainingProgressController extends GetxController {
  final Set<int> levelOneCompletedIndices = {};
  final Set<String> completedTrainingTitles = {};

  static void ensureRegistered() {
    if (!Get.isRegistered<TrainingProgressController>()) {
      Get.put(TrainingProgressController());
    }
  }

  void completeLevelOneLesson(int levelIndex, String trainingTitle) {
    levelOneCompletedIndices.add(levelIndex);
    if (trainingTitle.isNotEmpty) {
      completedTrainingTitles.add(trainingTitle);
    }
  }

  void markTrainingLessonCompleted(String title) {
    completedTrainingTitles.add(title);
  }

  bool isTrainingTitleCompleted(String title) =>
      completedTrainingTitles.contains(title);
}
