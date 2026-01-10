import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../network/dio_client.dart';
import '../models/user_info.dart';

class UserService {
  // ===================== GET MY INFO =====================
  static Future<UserInfo> getMyInfo() async {
    try {
      final response = await DioClient.dio.get("/users/myInfo");

      if (response.statusCode != 200) {
        throw Exception(
          "Failed to fetch user info (status code: ${response.statusCode})",
        );
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response format");
      }

      final result = data['result'];
      if (result == null || result is! Map<String, dynamic>) {
        throw Exception("User info not found");
      }

      return UserInfo.fromJson(result);
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? e.response?.data['message'] ?? e.response?.data.toString()
              : e.message;
      throw Exception("Failed to fetch user info: $message");
    }
  }

  // ===================== UPDATE GENDER =====================
  static Future<void> updateUserGender({
    required int userId,
    required String gender,
  }) async {
    try {
      final response = await DioClient.dio.put(
        "/users/$userId",
        data: {"gender": gender},
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update gender");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "Failed to update gender",
      );
    }
  }

  static Future<UserInfo> updateProfile({
    required int userId,
    required String fullName,
    required String email,
    String? phoneNumber,
    String? gender,
    DateTime? birthday,
  }) async {
    try {
      final requestData = {
        'fullName': fullName,
        'email': email,
        // ✅ KHÔNG gửi passwordHash
        if (phoneNumber != null && phoneNumber.isNotEmpty)
          'phoneNumber': phoneNumber,
        if (gender != null)
          'gender': gender,
        if (birthday != null)
          'birthday': _formatDate(birthday),
      };

      debugPrint('🔵 Request data: $requestData');

      final response = await DioClient.dio.put(
        "/users/$userId",
        data: requestData,
      );

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response format");
      }

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Update failed');
      }

      final result = data['result'];
      if (result == null || result is! Map<String, dynamic>) {
        throw Exception("Profile update failed");
      }

      debugPrint('✅ Profile updated successfully');
      return UserInfo.fromJson(result);

    } on DioException catch (e) {
      debugPrint('❌ Update profile DioException:');
      debugPrint('  Status: ${e.response?.statusCode}');
      debugPrint('  Data: ${e.response?.data}');

      final message =
      e.response?.data is Map
          ? e.response?.data['message'] ?? e.response?.data.toString()
          : e.message;
      throw Exception("Failed to update profile: $message");
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
