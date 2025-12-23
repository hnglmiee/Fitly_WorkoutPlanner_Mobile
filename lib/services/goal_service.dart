import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../models/goal_progress.dart';
import '../network/dio_client.dart';

class GoalService {
  static Future<GoalProgress?> fetchGoalProgress() async {
    try {
      final dio = DioClient.dio;
      final response = await dio.get('/goal/progress');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      final result = data['result'];
      if (result == null) return null;

      return GoalProgress.fromJson(result);
    } catch (e, stack) {
      debugPrint('fetchGoalProgress error: $e');
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }
}
