import 'package:flutter/material.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';

class ContactSubmitResult {
  const ContactSubmitResult({required this.success, required this.message});

  final bool success;
  final String message;
}

class ContactSupportService {
  ContactSupportService({NetworkApiServices? api})
    : _api = api ?? NetworkApiServices();

  final NetworkApiServices _api;

  static bool _isOk(Map<String, dynamic> map) {
    return map['success'] == true || map['status'] == true;
  }

  /// POST `/contacts/create`
  Future<ContactSubmitResult> submit({
    required String name,
    required String email,
    required String subject,
    required String message,
    BuildContext? context,
  }) async {
    final dynamic raw = await _api.postApi(
      url: ApiConfig.url(ApiConfig.contactsCreate),
      context: context,
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'subject': subject.trim(),
        'message': message.trim(),
      },
      showSnackbar: false,
    );

    if (raw == null || raw is! Map) {
      return const ContactSubmitResult(
        success: false,
        message: 'Something went wrong. Please try again.',
      );
    }

    final map = Map<String, dynamic>.from(raw);
    if (_isOk(map)) {
      final msg =
          map['message']?.toString().trim() ??
          'Your message has been sent successfully.';
      return ContactSubmitResult(success: true, message: msg);
    }

    final err =
        map['message']?.toString() ??
        map['error']?.toString() ??
        'Failed to send message';
    return ContactSubmitResult(success: false, message: err);
  }
}
