import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/progress_overview_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class ProgressOverviewService {
  ProgressOverviewService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    if (map['success'] == true) return true;
    final status = map['status'];
    return status == true ||
        status == 'success' ||
        (status is String && status.toLowerCase() == 'success');
  }

  Future<ProgressOverviewData?> fetchOverview({BuildContext? context}) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.progressOverview),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) return null;

    final map = Map<String, dynamic>.from(raw);
    if (!_isOk(map)) {
      throw Exception(map['message']?.toString() ?? 'Failed to load progress');
    }

    final data = map['data'];
    if (data is! Map) return null;

    return ProgressOverviewData.fromJson(Map<String, dynamic>.from(data));
  }
}
