import 'package:tang_soo_karate/services/api/api_config.dart';

class LessonMedia {
  const LessonMedia({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.url,
    this.thumbnail,
    this.provider,
    this.mimeType,
    this.duration,
    this.order,
  });

  final int id;
  final int lessonId;
  final String type;
  final String url;
  /// Signed URL or path to poster image (often on VIDEO rows from S3).
  final String? thumbnail;
  final String? provider;
  final String? mimeType;
  final int? duration;
  final int? order;

  factory LessonMedia.fromJson(Map<String, dynamic> j) {
    final thumb = j['thumbnail']?.toString();
    return LessonMedia(
      id: (j['id'] as num?)?.toInt() ?? 0,
      lessonId: (j['lessonId'] as num?)?.toInt() ?? 0,
      type: j['type']?.toString() ?? '',
      url: j['url']?.toString() ?? '',
      thumbnail: (thumb != null && thumb.trim().isNotEmpty) ? thumb.trim() : null,
      provider: j['provider']?.toString(),
      mimeType: j['mimeType']?.toString(),
      duration: (j['duration'] as num?)?.toInt(),
      order: (j['order'] as num?)?.toInt(),
    );
  }
}

class BeltLesson {
  const BeltLesson({
    required this.id,
    required this.title,
    this.slug,
    this.shortDescription,
    this.content,
    required this.beltLevelId,
    required this.order,
    required this.isPublished,
    this.accessRule,
    required this.durationSeconds,
    required this.media,
    required this.isLocked,
    required this.isCompleted,
    required this.isBookmarked,
    required this.completionPercent,
  });

  final int id;
  final String title;
  final String? slug;
  final String? shortDescription;
  final String? content;
  final int beltLevelId;
  final int order;
  final bool isPublished;
  final String? accessRule;
  final int durationSeconds;
  final List<LessonMedia> media;
  final bool isLocked;
  final bool isCompleted;
  final bool isBookmarked;
  final int completionPercent;

  String? get firstVideoUrl {
    for (final m in media) {
      if (m.type.toUpperCase() == 'VIDEO' && m.url.trim().isNotEmpty) {
        return m.url.trim();
      }
    }
    return null;
  }

  /// Poster for list rows: API `media[].thumbnail` (e.g. S3), then image URL, then YouTube still.
  String? get thumbnailUrl {
    for (final m in media) {
      final thumb = m.thumbnail?.trim();
      if (thumb != null && thumb.isNotEmpty) {
        return _absoluteMedia(thumb);
      }
    }
    for (final m in media) {
      final t = m.type.toUpperCase();
      if ((t == 'IMAGE' || t == 'THUMBNAIL' || t == 'POSTER') &&
          m.url.trim().isNotEmpty) {
        return _absoluteMedia(m.url.trim());
      }
    }
    final video = firstVideoUrl;
    if (video != null && video.isNotEmpty) {
      final id = _youtubeVideoId(video);
      if (id != null && id.isNotEmpty) {
        return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
      }
      final lower = video.toLowerCase();
      if (lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.png') ||
          lower.endsWith('.webp')) {
        return _absoluteMedia(video);
      }
    }
    return null;
  }

  static String _absoluteMedia(String pathOrUrl) {
    return ApiConfig.absoluteMediaUrl(pathOrUrl) ?? pathOrUrl;
  }

  static String? _youtubeVideoId(String raw) {
    final u = raw.trim();
    if (u.isEmpty) return null;
    try {
      final uri = Uri.parse(u);
      final host = uri.host.toLowerCase();
      if (host.contains('youtu.be')) {
        if (uri.pathSegments.isEmpty) return null;
        final id = uri.pathSegments.first;
        return id.isNotEmpty ? id : null;
      }
      if (host.contains('youtube.com')) {
        final v = uri.queryParameters['v'];
        if (v != null && v.isNotEmpty) return v;
        final path = uri.path;
        final embed = path.indexOf('/embed/');
        if (embed >= 0) {
          final rest = path.substring(embed + '/embed/'.length);
          final id = rest.split('/').first.split('?').first;
          if (id.isNotEmpty) return id;
        }
        final shorts = path.indexOf('/shorts/');
        if (shorts >= 0) {
          final rest = path.substring(shorts + '/shorts/'.length);
          final id = rest.split('/').first.split('?').first;
          if (id.isNotEmpty) return id;
        }
      }
    } catch (_) {}
    return null;
  }

  factory BeltLesson.fromJson(Map<String, dynamic> j) {
    final rawMedia = j['media'];
    final media = <LessonMedia>[];
    if (rawMedia is List) {
      for (final e in rawMedia) {
        if (e is Map) {
          media.add(LessonMedia.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return BeltLesson(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title']?.toString() ?? '',
      slug: j['slug']?.toString(),
      shortDescription: j['shortDescription']?.toString(),
      content: j['content']?.toString(),
      beltLevelId: (j['beltLevelId'] as num?)?.toInt() ?? 0,
      order: (j['order'] as num?)?.toInt() ?? 0,
      isPublished: j['isPublished'] == true,
      accessRule: j['accessRule']?.toString(),
      durationSeconds: (j['durationSeconds'] as num?)?.toInt() ?? 0,
      media: media,
      isLocked: j['isLocked'] == true,
      isCompleted: j['isCompleted'] == true,
      isBookmarked: j['isBookmarked'] == true,
      completionPercent: (j['completionPercent'] as num?)?.toInt() ?? 0,
    );
  }
}

class BeltLessonsGroup {
  const BeltLessonsGroup({
    required this.beltLevelId,
    required this.beltName,
    required this.lessons,
  });

  final int beltLevelId;
  final String beltName;
  final List<BeltLesson> lessons;

  factory BeltLessonsGroup.fromJson(Map<String, dynamic> j) {
    final rawLessons = j['lessons'];
    final lessons = <BeltLesson>[];
    if (rawLessons is List) {
      for (final e in rawLessons) {
        if (e is Map) {
          lessons.add(BeltLesson.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    lessons.sort((a, b) => a.order.compareTo(b.order));
    return BeltLessonsGroup(
      beltLevelId: (j['beltLevelId'] as num?)?.toInt() ?? 0,
      beltName: j['beltName']?.toString() ?? '',
      lessons: lessons,
    );
  }
}
