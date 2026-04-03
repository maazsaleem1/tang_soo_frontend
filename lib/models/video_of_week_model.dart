class VideoOfWeekLesson {
  final int id;
  final String title;
  final String? shortDescription;
  final String? content;

  const VideoOfWeekLesson({
    required this.id,
    required this.title,
    this.shortDescription,
    this.content,
  });

  factory VideoOfWeekLesson.fromJson(Map<String, dynamic> j) {
    return VideoOfWeekLesson(
      id: (j['id'] as num?)?.toInt() ?? 0,
      title: j['title']?.toString() ?? '',
      shortDescription: j['shortDescription']?.toString(),
      content: j['content']?.toString(),
    );
  }
}

class VideoOfWeekModel {
  final int id;
  final int lessonId;
  final String type;
  final String url;
  final String? provider;
  final VideoOfWeekLesson lesson;

  const VideoOfWeekModel({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.url,
    this.provider,
    required this.lesson,
  });

  factory VideoOfWeekModel.fromJson(Map<String, dynamic> j) {
    final lessonRaw = j['lesson'];
    final lessonMap =
        lessonRaw is Map
            ? Map<String, dynamic>.from(lessonRaw)
            : <String, dynamic>{};

    return VideoOfWeekModel(
      id: (j['id'] as num?)?.toInt() ?? 0,
      lessonId: (j['lessonId'] as num?)?.toInt() ?? 0,
      type: j['type']?.toString() ?? 'VIDEO',
      url: j['url']?.toString() ?? '',
      provider: j['provider']?.toString(),
      lesson: VideoOfWeekLesson.fromJson(lessonMap),
    );
  }

  /// YouTube URLs must use the YouTube player (not [VideoPlayerController] / Chewie).
  static bool isYoutubeUrl(String url) {
    final u = url.toLowerCase();
    return u.contains('youtube.com/embed') ||
        u.contains('youtube.com/watch') ||
        u.contains('youtu.be');
  }
}
