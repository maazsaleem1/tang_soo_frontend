import 'package:flutter/material.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class LessonProgressService {
  LessonProgressService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    if (map['success'] == true) return true;
    final status = map['status'];
    return status == true ||
        status == 'success' ||
        (status is String && status.toLowerCase() == 'success');
  }

  /// POST `/progress/track` — marks a lesson completed for the current user.
  Future<void> markLessonCompleted({
    required int lessonId,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.postApi(
      url: ApiConfig.url(ApiConfig.progressTrack),
      body: <String, dynamic>{
        'lessonId': lessonId,
        'status': 'completed',
      },
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) {
      throw Exception('Invalid response from server');
    }

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(map['message']?.toString() ?? 'Failed to save progress');
    }
  }

  /// POST `/progress/track` — bookmarks a lesson for the current user.
  Future<void> markLessonBookmarked({
    required int lessonId,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.postApi(
      url: ApiConfig.url(ApiConfig.progressTrack),
      body: <String, dynamic>{
        'lessonId': lessonId,
        'status': 'bookmarked',
      },
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) {
      throw Exception('Invalid response from server');
    }

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(map['message']?.toString() ?? 'Failed to save bookmark');
    }
  }
}
