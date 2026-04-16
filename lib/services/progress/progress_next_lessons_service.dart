import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/progress_next_lesson_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class NextLessonsPageResult {
  const NextLessonsPageResult({required this.lessons, this.pagination});

  final List<ProgressNextLesson> lessons;
  final NextLessonsPagination? pagination;
}

class ProgressNextLessonsService {
  ProgressNextLessonsService({NetworkApiServices? api})
    : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    if (map['success'] == true) return true;
    if (map['status'] == true) return true;
    final status = map['status'];
    return status == 'success' ||
        (status is String && status.toLowerCase() == 'success');
  }

  /// GET `/lessons/{lessonId}/next` — [lessonId] is usually [CurrentLesson.id] from overview.
  Future<NextLessonsPageResult> fetchNextAfterLesson({
    required int lessonId,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.lessonNext(lessonId)),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) {
      throw Exception('Invalid response from server');
    }

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(
        map['message']?.toString() ?? 'Failed to load next lessons',
      );
    }

    final data = map['data'];
    final lessons = <ProgressNextLesson>[];
    if (data is List) {
      for (final e in data) {
        if (e is Map) {
          lessons.add(
            ProgressNextLesson.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    } else if (data is Map) {
      lessons.add(ProgressNextLesson.fromJson(Map<String, dynamic>.from(data)));
    }

    NextLessonsPagination? pagination;
    final rawPag = map['pagination'];
    if (rawPag is Map) {
      pagination = NextLessonsPagination.fromJson(
        Map<String, dynamic>.from(rawPag),
      );
    }

    return NextLessonsPageResult(lessons: lessons, pagination: pagination);
  }
}
