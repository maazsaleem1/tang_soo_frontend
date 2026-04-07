import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tang_soo_karate/models/user_model.dart';
import 'package:tang_soo_karate/services/api/api_config.dart';
import 'package:tang_soo_karate/services/api/api_service.dart';
import 'package:tang_soo_karate/services/api/api_storage.dart';

class AuthService {
  AuthService({NetworkApiServices? apiService})
    : _apiService = apiService ?? NetworkApiServices();

  final NetworkApiServices _apiService;

  Future<void> _persistAuthData(Map<String, dynamic>? data) async {
    if (data == null) return;

    final token = data['token']?.toString();
    if (token != null && token.isNotEmpty) {
      await ApiStorage.setToken(token);
    }

    final nestedUser = (data['user'] as Map?)?.cast<String, dynamic>();
    final sourceUser = nestedUser ?? data;
    if (sourceUser.isEmpty) return;

    final existingToken = await ApiStorage.getToken();
    final userToken = sourceUser['token']?.toString();
    final mergedToken =
        (token != null && token.isNotEmpty)
            ? token
            : (userToken != null && userToken.isNotEmpty)
                ? userToken
                : (existingToken ?? '');

    final normalizedUser = <String, dynamic>{
      ...sourceUser,
      'token': mergedToken,
      'status':
          sourceUser['status'] ??
          ((sourceUser['isActive'] == true) ? 'active' : 'inactive'),
    };

    await ApiStorage.setUser(UserModel.fromJson(normalizedUser));
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    final response = await _apiService.postApi(
      url: ApiConfig.url(ApiConfig.login),
      context: context,
      body: {'email': email, 'password': password},
    );
    final parsed =
        (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    final data = (parsed['data'] as Map?)?.cast<String, dynamic>();
    await _persistAuthData(data);
    return parsed;
  }

  Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    BuildContext? context,
    File? profileImage,
  }) async {
    if (profileImage != null) {
      final response = await _apiService.postMultiPartApi(
        url: ApiConfig.url(ApiConfig.signup),
        context: context,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
        singleFiles: {'profile_image': profileImage.path},
      );
      final parsed =
          (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
      final data = (parsed['data'] as Map?)?.cast<String, dynamic>();
      await _persistAuthData(data);
      return parsed;
    }

    final response = await _apiService.postApi(
      url: ApiConfig.url(ApiConfig.signup),
      context: context,
      body: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      },
    );
    final parsed =
        (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    final data = (parsed['data'] as Map?)?.cast<String, dynamic>();
    await _persistAuthData(data);
    return parsed;
  }

  Future<Map<String, dynamic>> forgotPassword({
    required String email,
    BuildContext? context,
  }) async {
    final response = await _apiService.postApi(
      url: ApiConfig.url(ApiConfig.forgotPassword),
      context: context,
      body: {'email': email},
    );
    return (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    BuildContext? context,
  }) async {
    final response = await _apiService.postApi(
      url: ApiConfig.url(ApiConfig.verifyOtp),
      context: context,
      body: {'otp': otp},
    );
    return (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> resendOtp({BuildContext? context}) async {
    final response = await _apiService.getApi(
      url: ApiConfig.url(ApiConfig.resendOtp),
      context: context,
    );
    return (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> resetPassword({
    required String oldPassword,
    required String newPassword,
    BuildContext? context,
    bool showSnackbar = true,
  }) async {
    final response = await _apiService.putApi(
      url: ApiConfig.url(ApiConfig.resetPassword),
      context: context,
      body: {'oldPassword': oldPassword, 'newPassword': newPassword},
      showSnackbar: showSnackbar,
    );
    return (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
  }

  /// PATCH `/users/profile` — form fields + optional `profileImage` file.
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String dob,
    required String country,
    required String postalCode,
    required String address,
    required String mobile,
    String notificationStatus = 'No',
    BuildContext? context,
    File? profileImage,
  }) async {
    final fields = <String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'country': country,
      'postalCode': postalCode,
      'address': address,
      'mobile': mobile,
      'notificationStatus': notificationStatus,
    };

    final Map<String, String>? files =
        profileImage != null ? {'profileImage': profileImage.path} : null;

    final response = await _apiService.patchMultiPartApi(
      url: ApiConfig.url(ApiConfig.updateProfile),
      context: context,
      data: fields,
      singleFiles: files,
    );

    final parsed =
        (response as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{};
    if (parsed['success'] == true) {
      final data = (parsed['data'] as Map?)?.cast<String, dynamic>();
      await _persistAuthData(data);
    }
    return parsed;
  }
}
