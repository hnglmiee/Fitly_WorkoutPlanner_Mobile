import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/auth_response.dart';

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

      return AuthResponse(token: token);
    } on DioException catch (e) {
      final message =
          e.response?.data is Map
              ? e.response?.data['message']
              : "Login failed";
      throw Exception(message);
    }
  }
}
