import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/cms_page_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class CmsPagesService {
  CmsPagesService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  /// GET `/pages/{slug}` — e.g. [slug] `term` for Terms & Conditions.
  Future<CmsPageModel> fetchPage({
    required String slug,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.pageBySlug(slug)),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) {
      throw Exception('Invalid response');
    }

    final map = Map<String, dynamic>.from(raw);
    if (map['success'] != true) {
      throw Exception(map['message']?.toString() ?? 'Failed to load page');
    }

    final data = map['data'];
    if (data is! Map) {
      throw Exception('Missing page data');
    }

    return CmsPageModel.fromJson(Map<String, dynamic>.from(data));
  }
}
