import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/user_info.dart';

class UserService {
  // static String? _token;
  //
  // // ===================== TOKEN =====================
  // static void setToken(String t) {
  //   _token = t;
  //
  //   // set global Authorization header
  //   DioClient.dio.options.headers['Authorization'] = 'Bearer $t';
  // }
  //
  // static String? getToken() => _token;

  // ===================== GET MY INFO =====================
  static Future<UserInfo> getMyInfo() async {
    // if (_token == null) {
    //   throw Exception("Token not set. Please login first.");
    // }

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
}
