import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/workout_plan.dart';
import '../network/dio_client.dart';

class WorkoutPlanService {
  static Future<List<WorkoutPlan>> fetchMyPlans() async {
    try {
      debugPrint('🔵 Fetching workout plans...');

      final dio = DioClient.dio;
      final response = await dio.get('/workout-plans/my-plans');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data type: ${response.data.runtimeType}');
      debugPrint('🔵 Response data: ${response.data}');

      // Parse response
      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      debugPrint('🔵 Parsed data: $data');

      // ✅ Check if response is successful
      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Result list length: ${list.length}');

      if (list.isEmpty) {
        debugPrint('⚠️ No workout plans found');
        return []; // ✅ Return empty list (not error)
      }

      final plans =
          list.map((e) {
            debugPrint('🔵 Parsing plan: $e');
            return WorkoutPlan.fromJson(e);
          }).toList();

      debugPrint('✅ Successfully fetched ${plans.length} plans');
      return plans;
    } catch (e, stack) {
      debugPrint('❌ fetchMyPlans error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow; // ✅ IMPORTANT: Throw error instead of returning []
    }
  }
}
