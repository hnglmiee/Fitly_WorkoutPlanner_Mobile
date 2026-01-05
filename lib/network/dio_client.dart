// dio_client.dart
import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      // baseUrl: "http://192.168.2.22:8080/api/v1",
      baseUrl: "http://10.0.2.2:8080/api/v1",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    ),
  )..interceptors.add(AuthInterceptor());
}
