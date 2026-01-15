import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/workout_chart_item.dart';
import '../network/dio_client.dart';

class WorkoutService {

  /// 🔥 Fetch weekly workout chart
  static Future<List<WorkoutChartItem>> fetchWeeklyWorkoutChart() async {
    try {
      debugPrint('🔵 ============================================');
      debugPrint('🔵 Fetching weekly workout chart...');
      debugPrint('🔵 ============================================');

      final dio = DioClient.dio;
      final response = await dio.get('/goal/workouts/chart/weekly');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        debugPrint('❌ API error code: ${data['code']}');
        debugPrint('❌ Message: ${data['message']}');
        return [];
      }

      final List result = data['result'] ?? [];

      if (result.isEmpty) {
        debugPrint('⚠️ No workout data found');
        return [];
      }

      final List<WorkoutChartItem> items = [];

      for (int i = 0; i < result.length; i++) {
        try {
          final item = WorkoutChartItem.fromJson(result[i]);
          items.add(item);
          debugPrint('  ✓ ${item.label}: ${item.sessions} sessions');
        } catch (e) {
          debugPrint('  ⚠️ Failed to parse workout item #$i: $e');
        }
      }

      debugPrint('✅ Loaded ${items.length} workout chart items');
      debugPrint('🔵 ============================================');

      return items;

    } on DioException catch (e) {
      debugPrint('❌ fetchWeeklyWorkoutChart DioException');
      debugPrint('  Status code: ${e.response?.statusCode}');
      debugPrint('  Response: ${e.response?.data}');
      return [];

    } catch (e, stack) {
      debugPrint('❌ fetchWeeklyWorkoutChart unexpected error: $e');
      debugPrintStack(stackTrace: stack);
      return [];
    }
  }
}
