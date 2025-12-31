// lib/services/workout_plan_service.dart
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

  // ✅ THÊM MỚI - Create new plan
  static Future<WorkoutPlan> createPlan({
    required String title,
    required String notes,
  }) async {
    try {
      debugPrint('🔵 Creating workout plan...');

      final dio = DioClient.dio;
      final response = await dio.post(
        '/workout-plans',
        data: {'title': title, 'notes': notes},
      );

      debugPrint('🔵 Create response: ${response.data}');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to create plan');
      }

      debugPrint('✅ Plan created successfully');
      return WorkoutPlan.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ createPlan error: $e');
      rethrow;
    }
  }

  // ✅ THÊM MỚI - Update plan
  static Future<WorkoutPlan> updatePlan({
    required int planId,
    required String title,
    required String notes,
  }) async {
    try {
      debugPrint('🔵 Updating workout plan $planId...');

      final dio = DioClient.dio;
      final response = await dio.put(
        '/workout-plans/$planId',
        data: {'title': title, 'notes': notes},
      );

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to update plan');
      }

      debugPrint('✅ Plan updated successfully');
      return WorkoutPlan.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ updatePlan error: $e');
      rethrow;
    }
  }

  // ✅ THÊM MỚI - Delete plan
  static Future<void> deletePlan(int planId) async {
    try {
      debugPrint('🔵 Deleting workout plan $planId...');

      final dio = DioClient.dio;
      final response = await dio.delete('/workout-plans/$planId');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to delete plan');
      }

      debugPrint('✅ Plan deleted successfully');
    } catch (e) {
      debugPrint('❌ deletePlan error: $e');
      rethrow;
    }
  }

  // ✅ THÊM MỚI - Get plan by ID
  static Future<WorkoutPlan> getPlanById(int planId) async {
    try {
      debugPrint('🔵 Fetching workout plan $planId...');

      final dio = DioClient.dio;
      final response = await dio.get('/workout-plans/$planId');

      final data =
          response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to get plan');
      }

      debugPrint('✅ Plan fetched successfully');
      return WorkoutPlan.fromJson(data['result']);
    } catch (e) {
      debugPrint('❌ getPlanById error: $e');
      rethrow;
    }
  }

  // ✅ THÊM MỚI - Refresh token nếu cần
  static Future<void> refreshPlansCache() async {
    debugPrint('🔄 Refreshing plans cache...');
    // Implement caching logic if needed
  }
}
