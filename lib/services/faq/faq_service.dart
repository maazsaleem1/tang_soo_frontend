import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/faq_item_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class FaqService {
  FaqService({NetworkApiServices? api}) : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  /// GET `/faq` — returns FAQ list sorted by `order`.
  Future<List<FaqItemModel>> fetchFaqs({BuildContext? context}) async {
    final dynamic raw = await _api.getApi(
      url: ApiConfig.url(ApiConfig.faq),
      context: context,
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) return [];

    final map = Map<String, dynamic>.from(raw);
    if (map['success'] != true) {
      throw Exception(map['message']?.toString() ?? 'Failed to load FAQs');
    }

    final data = map['data'];
    if (data is! List) return [];

    final items = <FaqItemModel>[];
    for (final e in data) {
      if (e is Map) {
        items.add(FaqItemModel.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return items;
  }
}
