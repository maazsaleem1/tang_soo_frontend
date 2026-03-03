import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_storage.dart';
import 'package:tang_soo_karate/services/api/api_toast.dart';
import 'package:tang_soo_karate/services/api/token_validator.dart';

class NetworkApiServices {
  NetworkApiServices({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> postApi({
    required String url,
    BuildContext? context,
    dynamic body,
    bool sendHeaders = true,
    bool showLoader = false,
    bool showSnackbar = true,
  }) async {
    final token = await ApiStorage.getToken();
    dynamic responseJson;

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (sendHeaders && (token?.isNotEmpty ?? false))
          'Authorization': 'Bearer $token',
      };

      final response =
          body != null
              ? await _client
                  .post(
                    Uri.parse(url),
                    headers: headers,
                    body: jsonEncode(body),
                  )
                  .timeout(ApiConfig.connectTimeout)
              : await _client
                  .post(Uri.parse(url), headers: headers)
                  .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 401 && sendHeaders) {
        final refreshSuccess = await _attemptTokenRefresh();
        if (refreshSuccess) {
          final newToken = await ApiStorage.getToken();
          final newHeaders = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (newToken?.isNotEmpty ?? false)
              'Authorization': 'Bearer $newToken',
          };

          final retryResponse =
              body != null
                  ? await _client
                      .post(
                        Uri.parse(url),
                        headers: newHeaders,
                        body: jsonEncode(body),
                      )
                      .timeout(ApiConfig.connectTimeout)
                  : await _client
                      .post(Uri.parse(url), headers: newHeaders)
                      .timeout(ApiConfig.connectTimeout);

          responseJson =
              showSnackbar
                  ? returnResponse(retryResponse, context: context)
                  : _safeDecode(retryResponse.body);
        } else {
          responseJson =
              showSnackbar
                  ? returnResponse(response, context: context)
                  : _safeDecode(response.body);
        }
      } else {
        responseJson =
            showSnackbar
                ? returnResponse(response, context: context)
                : _safeDecode(response.body);
      }
    } catch (e) {
      AppErrorToast(title: e.toString()).showToast(context);
    }

    return responseJson;
  }

  Future<dynamic> patchApi({
    required String url,
    BuildContext? context,
    dynamic body,
    bool sendHeaders = true,
    bool showLoader = false,
    bool showSnackbar = true,
  }) async {
    final token = await ApiStorage.getToken();
    dynamic responseJson;

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (sendHeaders && (token?.isNotEmpty ?? false))
          'Authorization': 'Bearer $token',
      };

      final response =
          body != null
              ? await _client
                  .patch(
                    Uri.parse(url),
                    headers: headers,
                    body: jsonEncode(body),
                  )
                  .timeout(ApiConfig.connectTimeout)
              : await _client
                  .patch(Uri.parse(url), headers: headers)
                  .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 401 && sendHeaders) {
        final refreshSuccess = await _attemptTokenRefresh();
        if (refreshSuccess) {
          final newToken = await ApiStorage.getToken();
          final newHeaders = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (newToken?.isNotEmpty ?? false)
              'Authorization': 'Bearer $newToken',
          };

          final retryResponse =
              body != null
                  ? await _client
                      .patch(
                        Uri.parse(url),
                        headers: newHeaders,
                        body: jsonEncode(body),
                      )
                      .timeout(ApiConfig.connectTimeout)
                  : await _client
                      .patch(Uri.parse(url), headers: newHeaders)
                      .timeout(ApiConfig.connectTimeout);

          responseJson =
              showSnackbar
                  ? returnResponse(retryResponse, context: context)
                  : _safeDecode(retryResponse.body);
        } else {
          responseJson =
              showSnackbar
                  ? returnResponse(response, context: context)
                  : _safeDecode(response.body);
        }
      } else {
        responseJson =
            showSnackbar
                ? returnResponse(response, context: context)
                : _safeDecode(response.body);
      }
    } catch (e) {
      AppErrorToast(title: e.toString()).showToast(context);
    }

    return responseJson;
  }

  Future<dynamic> putApi({
    required String url,
    BuildContext? context,
    dynamic body,
    bool sendHeaders = true,
    bool showLoader = false,
    bool showSnackbar = true,
  }) async {
    final token = await ApiStorage.getToken();
    dynamic responseJson;

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (sendHeaders && (token?.isNotEmpty ?? false))
          'Authorization': 'Bearer $token',
      };

      final response =
          body != null
              ? await _client
                  .put(
                    Uri.parse(url),
                    headers: headers,
                    body: jsonEncode(body),
                  )
                  .timeout(ApiConfig.connectTimeout)
              : await _client
                  .put(Uri.parse(url), headers: headers)
                  .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 401 && sendHeaders) {
        final refreshSuccess = await _attemptTokenRefresh();
        if (refreshSuccess) {
          final newToken = await ApiStorage.getToken();
          final newHeaders = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (newToken?.isNotEmpty ?? false)
              'Authorization': 'Bearer $newToken',
          };

          final retryResponse =
              body != null
                  ? await _client
                      .put(
                        Uri.parse(url),
                        headers: newHeaders,
                        body: jsonEncode(body),
                      )
                      .timeout(ApiConfig.connectTimeout)
                  : await _client
                      .put(Uri.parse(url), headers: newHeaders)
                      .timeout(ApiConfig.connectTimeout);

          responseJson =
              showSnackbar
                  ? returnResponse(retryResponse, context: context)
                  : _safeDecode(retryResponse.body);
        } else {
          responseJson =
              showSnackbar
                  ? returnResponse(response, context: context)
                  : _safeDecode(response.body);
        }
      } else {
        responseJson =
            showSnackbar
                ? returnResponse(response, context: context)
                : _safeDecode(response.body);
      }
    } catch (e) {
      AppErrorToast(title: e.toString()).showToast(context);
    }

    return responseJson;
  }

  Future<dynamic> getApi({
    required String url,
    BuildContext? context,
    bool showLoader = false,
    bool showSnackbar = false,
    bool sendHeaders = true,
  }) async {
    final token = await ApiStorage.getToken();
    dynamic responseJson;

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (sendHeaders && (token?.isNotEmpty ?? false))
          'Authorization': 'Bearer $token',
      };

      final response = await _client
          .get(Uri.parse(url), headers: headers)
          .timeout(ApiConfig.connectTimeout);

      if (response.statusCode == 401 && sendHeaders) {
        final refreshSuccess = await _attemptTokenRefresh();
        if (refreshSuccess) {
          final newToken = await ApiStorage.getToken();
          final newHeaders = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            if (newToken?.isNotEmpty ?? false)
              'Authorization': 'Bearer $newToken',
          };

          final retryResponse = await _client
              .get(Uri.parse(url), headers: newHeaders)
              .timeout(ApiConfig.connectTimeout);

          responseJson =
              showSnackbar
                  ? returnResponse(retryResponse, context: context)
                  : _safeDecode(retryResponse.body);
        } else {
          responseJson =
              showSnackbar
                  ? returnResponse(response, context: context)
                  : _safeDecode(response.body);
        }
      } else {
        responseJson =
            showSnackbar
                ? returnResponse(response, context: context)
                : _safeDecode(response.body);
      }
    } catch (e) {
      log('GET API error: $e');
      if (showSnackbar) {
        AppErrorToast(title: e.toString()).showToast(context);
      }
    }

    return responseJson;
  }

  Future<dynamic> postMultiPartApi({
    required String url,
    required Map<String, String> data,
    BuildContext? context,
    bool showLoader = false,
    bool showSnackbar = true,
    bool sendHeaders = true,
    Map<String, String>? singleFiles,
    Map<String, List<String>>? multiFiles,
  }) async {
    dynamic responseJson;
    final token = await ApiStorage.getToken();

    try {
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll(data);
      request.headers.addAll({
        'Accept': 'application/json',
        if (sendHeaders && (token?.isNotEmpty ?? false))
          'Authorization': 'Bearer $token',
      });

      if (singleFiles != null) {
        for (final entry in singleFiles.entries) {
          if (entry.value.trim().isNotEmpty) {
            request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value),
            );
          }
        }
      }

      if (multiFiles != null) {
        for (final entry in multiFiles.entries) {
          for (final filePath in entry.value) {
            if (filePath.trim().isNotEmpty) {
              request.files.add(
                await http.MultipartFile.fromPath(entry.key, filePath),
              );
            }
          }
        }
      }

      final streamedResponse = await request.send().timeout(
        ApiConfig.connectTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);

      responseJson =
          showSnackbar
              ? returnResponse(response, context: context)
              : _safeDecode(response.body);
    } catch (e) {
      AppErrorToast(title: e.toString()).showToast(context);
    }

    return responseJson;
  }

  dynamic returnResponse(http.Response response, {BuildContext? context}) {
    final statusCode = response.statusCode;
    final body = response.body.trim();

    try {
      if (_isHtmlResponse(body)) {
        AppErrorToast(
          title: 'Server error - received HTML response',
        ).showToast(context);
        return {
          'error': 'Server returned HTML instead of JSON',
          'statusCode': statusCode,
        };
      }

      final responseJson = _safeDecode(body);
      final message =
          responseJson is Map<String, dynamic>
              ? (responseJson['message']?.toString() ?? 'Request completed')
              : 'Request completed';

      if (statusCode == 200 || statusCode == 201) {
        AppSuccessToast(title: message).showToast(context);
        return responseJson;
      }

      if (statusCode == 401) {
        AppErrorToast(title: message).showToast(context);
        if (responseJson is Map<String, dynamic>) {
          return {
            ...responseJson,
            'statusCode': statusCode,
            'isUnauthorized': true,
            'errorType': 'unauthorized',
          };
        }
        return {
          'error': message,
          'statusCode': statusCode,
          'isUnauthorized': true,
          'errorType': 'unauthorized',
        };
      }

      if (statusCode >= 400) {
        AppErrorToast(title: message).showToast(context);
      } else {
        AppSuccessToast(title: message).showToast(context);
      }

      return responseJson;
    } catch (e) {
      log('JSON parsing error: $e');
      if (statusCode == 401) {
        AppErrorToast(
          title: 'Unauthorized - Please login again',
        ).showToast(context);
        return {
          'error': 'Unauthorized - Invalid or expired token',
          'statusCode': statusCode,
          'isUnauthorized': true,
          'errorType': 'unauthorized',
        };
      }
      AppErrorToast(title: 'Invalid response format').showToast(context);
      return {'error': 'Invalid response format', 'statusCode': statusCode};
    }
  }

  Future<bool> _attemptTokenRefresh() async {
    try {
      return await TokenValidator.refreshToken();
    } catch (e) {
      log('Error during token refresh: $e');
      return false;
    }
  }

  dynamic _safeDecode(String body) {
    if (body.isEmpty) return <String, dynamic>{};
    return jsonDecode(body);
  }

  bool _isHtmlResponse(String body) {
    return body.startsWith('<!DOCTYPE html>') ||
        body.startsWith('<html>') ||
        body.startsWith('<!DOCTYPE');
  }
}
