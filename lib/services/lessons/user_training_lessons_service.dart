import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/progress_next_lesson_model.dart';
import 'package:tang_soo_karate/models/user_training_lesson_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class UserTrainingLessonsService {
  UserTrainingLessonsService({NetworkApiServices? api})
    : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    if (map['success'] == true) return true;
    final status = map['status'];
    return status == true ||
        status == 'success' ||
        (status is String && status.toLowerCase() == 'success');
  }

  /// GET `/lessons/user/{filterKey}/filter` — [filterKey]: `all`, `isCompleted`, `isBookmarked`.
  Future<UserTrainingLessonsPageResult> fetchPage({
    required String filterKey,
    int page = 1,
    int limit = 10,
    String? search,
    BuildContext? context,
  }) async {
    final baseUri = Uri.parse(ApiConfig.url(ApiConfig.lessonsUserFilter(filterKey)));
    final q = <String, String>{
      'page': '$page',
      'limit': '$limit',
    };
    final s = search?.trim();
    if (s != null && s.isNotEmpty) {
      q['search'] = s;
    }
    final uri = baseUri.replace(queryParameters: q);
    final dynamic raw = await _api.getApi(
      url: uri.toString(),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) {
      throw Exception('Invalid response from server');
    }

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(
        map['message']?.toString() ?? 'Failed to load training lessons',
      );
    }

    final data = map['data'];
    final lessons = <UserTrainingLesson>[];
    if (data is List) {
      for (final e in data) {
        if (e is Map) {
          lessons.add(
            UserTrainingLesson.fromJson(Map<String, dynamic>.from(e)),
          );
        }
      }
    }

    NextLessonsPagination? pagination;
    final rawPag = map['pagination'];
    if (rawPag is Map) {
      pagination = NextLessonsPagination.fromJson(
        Map<String, dynamic>.from(rawPag),
      );
    }

    return UserTrainingLessonsPageResult(
      lessons: lessons,
      pagination: pagination,
    );
  }
}
