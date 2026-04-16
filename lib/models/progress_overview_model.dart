/// In-app lesson summary from [ProgressOverviewData.currentLesson] (API key `CurrentLesson`).
class ProgressCurrentLesson {
  const ProgressCurrentLesson({
    required this.id,
    required this.title,
    this.slug,
    this.shortDescription,
    this.content,
    this.beltLevelId,
    required this.order,
    this.durationSeconds = 0,
  });

  final int id;
  final String title;
  final String? slug;
  final String? shortDescription;
  final String? content;
  final int? beltLevelId;
  final int order;
  final int durationSeconds;

  factory ProgressCurrentLesson.fromJson(Map<String, dynamic> j) {
    return ProgressCurrentLesson(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title']?.toString() ?? '',
      slug: j['slug']?.toString(),
      shortDescription: j['shortDescription']?.toString(),
      content: j['content']?.toString(),
      beltLevelId: (j['beltLevelId'] as num?)?.toInt(),
      order: (j['order'] as num?)?.toInt() ?? 0,
      durationSeconds: (j['durationSeconds'] as num?)?.toInt() ?? 0,
    );
  }
}

class ProgressOverviewData {
  const ProgressOverviewData({
    required this.currentLevel,
    required this.overallPercentage,
    required this.completedLesson,
    required this.totalLessons,
    this.currentLesson,
  });

  final String currentLevel;
  final int overallPercentage;
  final int completedLesson;
  final int totalLessons;
  final ProgressCurrentLesson? currentLesson;

  double get overallFraction {
    final p = overallPercentage.clamp(0, 100);
    return p / 100.0;
  }

  factory ProgressOverviewData.fromJson(Map<String, dynamic> j) {
    final rawCur = j['CurrentLesson'] ?? j['currentLesson'];
    ProgressCurrentLesson? cur;
    if (rawCur is Map) {
      cur = ProgressCurrentLesson.fromJson(
        Map<String, dynamic>.from(rawCur),
      );
    }
    return ProgressOverviewData(
      currentLevel: j['currentLevel']?.toString() ?? '',
      overallPercentage: (j['overallPercentage'] as num?)?.toInt() ?? 0,
      completedLesson: (j['completedLesson'] as num?)?.toInt() ?? 0,
      totalLessons: (j['totalLessons'] as num?)?.toInt() ?? 0,
      currentLesson: cur,
    );
  }
}
