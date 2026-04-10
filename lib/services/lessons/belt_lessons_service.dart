import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/belt_lessons_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class BeltLessonsService {
  BeltLessonsService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    if (map['success'] == true) return true;
    final status = map['status'];
    return status == true ||
        status == 'success' ||
        (status is String && status.toLowerCase() == 'success');
  }

  /// GET `/lessons/belt/{beltId}`
  Future<BeltLessonsGroup?> fetchBeltLessons({
    required int beltId,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.lessonsBelt(beltId)),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) return null;

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(map['message']?.toString() ?? 'Failed to load belt lessons');
    }

    final data = map['data'];
    if (data is! List || data.isEmpty) return null;

    final first = data.first;
    if (first is! Map) return null;

    return BeltLessonsGroup.fromJson(Map<String, dynamic>.from(first));
  }
}
