import 'package:tang_soo_karate/models/belt_lessons_model.dart';
import 'package:tang_soo_karate/models/progress_next_lesson_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';

/// Row from GET `/lessons/user/{filter}/filter`.
class UserTrainingLesson {
  const UserTrainingLesson({
    required this.id,
    required this.title,
    this.slug,
    this.shortDescription,
    this.content,
    required this.beltLevelId,
    required this.order,
    required this.durationSeconds,
    required this.isCompleted,
    required this.isBookmarked,
    required this.isLocked,
    required this.completionPercent,
    this.media = const [],
  });

  final int id;
  final String title;
  final String? slug;
  final String? shortDescription;
  final String? content;
  final int beltLevelId;
  final int order;
  final int durationSeconds;
  final bool isCompleted;
  final bool isBookmarked;
  final bool isLocked;
  final int completionPercent;
  final List<LessonMedia> media;

  int get navigationBeltId => beltLevelId;

  String? get thumbnailUrl {
    for (final m in media) {
      final thumb = m.thumbnail?.trim();
      if (thumb != null && thumb.isNotEmpty) {
        return ApiConfig.absoluteMediaUrl(thumb) ?? thumb;
      }
    }
    for (final m in media) {
      final t = m.type.toUpperCase();
      if ((t == 'IMAGE' || t == 'THUMBNAIL' || t == 'POSTER') &&
          m.url.trim().isNotEmpty) {
        return ApiConfig.absoluteMediaUrl(m.url.trim()) ?? m.url.trim();
      }
    }
    return null;
  }

  factory UserTrainingLesson.fromJson(Map<String, dynamic> j) {
    final rawMedia = j['media'];
    final list = <LessonMedia>[];
    if (rawMedia is List) {
      for (final e in rawMedia) {
        if (e is Map) {
          list.add(LessonMedia.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return UserTrainingLesson(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title']?.toString() ?? '',
      slug: j['slug']?.toString(),
      shortDescription: j['shortDescription']?.toString(),
      content: j['content']?.toString(),
      beltLevelId: (j['beltLevelId'] as num?)?.toInt() ?? 0,
      order: (j['order'] as num?)?.toInt() ?? 0,
      durationSeconds: (j['durationSeconds'] as num?)?.toInt() ?? 0,
      isCompleted: j['isCompleted'] == true,
      isBookmarked: j['isBookmarked'] == true,
      isLocked: j['isLocked'] == true,
      completionPercent: (j['completionPercent'] as num?)?.toInt() ?? 0,
      media: list,
    );
  }
}

class UserTrainingLessonsPageResult {
  const UserTrainingLessonsPageResult({
    required this.lessons,
    this.pagination,
  });

  final List<UserTrainingLesson> lessons;
  final NextLessonsPagination? pagination;
}
