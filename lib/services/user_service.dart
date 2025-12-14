// user_service.dart
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/user_info.dart';

class UserService {
  static String? token;

  static void setToken(String t) {
    token = t;
    DioClient.dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static Future<UserInfo> getMyInfo() async {
    if (token == null) {
      throw Exception("Token not set. Please login first.");
    }

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
}
