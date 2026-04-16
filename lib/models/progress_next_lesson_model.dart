import 'package:tang_soo_karate/models/belt_lessons_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';

/// Row from GET next-lessons queue (`isUnlocked` from API).
class ProgressNextLesson {
  const ProgressNextLesson({
    required this.id,
    required this.title,
    this.slug,
    this.shortDescription,
    this.content,
    this.beltLevelId,
    required this.order,
    required this.durationSeconds,
    required this.media,
    required this.isUnlocked,
  });

  final int id;
  final String title;
  final String? slug;
  final String? shortDescription;
  final String? content;
  final int? beltLevelId;
  final int order;
  final int durationSeconds;
  final List<LessonMedia> media;
  final bool isUnlocked;

  /// When API omits belt, navigation still needs a belt id — adjust if backend adds belt.
  int get navigationBeltId => beltLevelId ?? 1;

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

  factory ProgressNextLesson.fromJson(Map<String, dynamic> j) {
    final rawMedia = j['media'];
    final list = <LessonMedia>[];
    if (rawMedia is List) {
      for (final e in rawMedia) {
        if (e is Map) {
          list.add(LessonMedia.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return ProgressNextLesson(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title']?.toString() ?? '',
      slug: j['slug']?.toString(),
      shortDescription: j['shortDescription']?.toString(),
      content: j['content']?.toString(),
      beltLevelId: j['beltLevelId'] == null
          ? null
          : (j['beltLevelId'] as num?)?.toInt(),
      order: (j['order'] as num?)?.toInt() ?? 0,
      durationSeconds: (j['durationSeconds'] as num?)?.toInt() ?? 0,
      media: list,
      isUnlocked: j['isUnlocked'] == true,
    );
  }
}

class NextLessonsPagination {
  const NextLessonsPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  factory NextLessonsPagination.fromJson(Map<String, dynamic> j) {
    return NextLessonsPagination(
      total: (j['total'] as num?)?.toInt() ?? 0,
      page: (j['page'] as num?)?.toInt() ?? 1,
      limit: (j['limit'] as num?)?.toInt() ?? 10,
      totalPages: (j['totalPages'] as num?)?.toInt() ?? 0,
      hasNext: j['hasNext'] == true,
      hasPrev: j['hasPrev'] == true,
    );
  }
}
