import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/user_inbody.dart';

class UserInbodyService {
  static Future<UserInbody?> getLatestInbody() async {
    final response = await DioClient.dio.get('/user-in-body/my-in-body');

    final data = response.data['result'] as List;

    if (data.isEmpty) return null;

    // record mới nhất (cuối list)
    return UserInbody.fromJson(data.last);
  }
}
