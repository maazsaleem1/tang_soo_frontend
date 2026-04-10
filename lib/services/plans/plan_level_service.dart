import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/plan_level_preview_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class PlanLevelService {
  PlanLevelService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    final status = map['status'];
    if (status == true ||
        status == 'success' ||
        (status is String && status.toLowerCase() == 'success')) {
      return true;
    }
    return map['success'] == true;
  }

  /// GET `/plans/{planId}/level`
  Future<PlanLevelPreviewData?> fetchPlanLevelPreview({
    required int planId,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.planLevel(planId)),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) return null;

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(
        map['message']?.toString() ?? 'Failed to load plan',
      );
    }

    final data = map['data'];
    if (data is! Map) return null;

    return PlanLevelPreviewData.fromJson(Map<String, dynamic>.from(data));
  }
}
