import 'package:dio/dio.dart';
import '../models/user_info.dart';
import '../network/dio_client.dart';
import '../models/auth_response.dart';
import '../utils/token_storage.dart';

class AuthService {
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/auth",
        data: {"email": email, "passwordHash": password},
      );

      if (response.statusCode != 200) {
        throw Exception("Login failed");
      }

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response format");
      }

      final result = data['result'];
      if (result == null || result is! Map<String, dynamic>) {
        throw Exception("Invalid login result");
      }

      final token = result['token'];
      if (token == null || token is! String) {
        throw Exception("Token not found");
      }

      final authResponse = AuthResponse(token: token);
      TokenStorage.setToken(authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? e.response?.data['message']
              : "Login failed";
      throw Exception(message);
    }
  }

  // --- REGISTER STEP 1 ---
  Future<UserInfo> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        "/users",
        data: {"fullName": fullName, "email": email, "passwordHash": password},
      );

      print("Register response status: ${response.statusCode}");
      print("Register response data: ${response.data}");

      if (response.statusCode != 200 && response.statusCode != 201) {
        final msg = response.data?['message'] ?? "Register failed";
        throw Exception(msg);
      }

      final data = response.data;
      if (data is! Map<String, dynamic> || data['result'] == null) {
        throw Exception("Invalid register response");
      }

      return UserInfo.fromJson(data['result']);
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? e.response?.data['message']
              : "Register failed";
      throw Exception(message);
    }
  }

  static Future<void> logout() async {
    await DioClient.dio.post("/auth/logout");
    await TokenStorage.clear();
  }
}
