import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/video_of_week_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class LessonService {
  LessonService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    return map['success'] == true || map['status'] == true;
  }

  /// GET `/lessons/video-of-the-week`
  Future<VideoOfWeekModel?> fetchVideoOfTheWeek({BuildContext? context}) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.videoOfTheWeek),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) return null;

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(
        map['message']?.toString() ?? 'Failed to load video of the week',
      );
    }

    final data = map['data'];
    if (data is! Map) return null;

    return VideoOfWeekModel.fromJson(Map<String, dynamic>.from(data));
  }
}
