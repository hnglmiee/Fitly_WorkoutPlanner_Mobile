// dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
      BaseOptions(
        baseUrl: "http://10.0.2.2:8080/api/v1",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    )
    ..interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
}
