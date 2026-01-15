// lib/services/goal_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/goal_progress.dart';
import '../models/goal_request.dart';
import '../network/dio_client.dart';

class GoalService {
  /// Fetch current goal progress
  static Future<GoalProgress?> fetchGoalProgress() async {
    try {
      debugPrint('🔵 Fetching goal progress...');

      final dio = DioClient.dio;
      final response = await dio.get('/goal/progress');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        debugPrint('⚠️ API returned code: ${data['code']}');
        debugPrint('⚠️ Message: ${data['message']}');
        return null;
      }

      final result = data['result'];
      if (result == null) {
        debugPrint('⚠️ No goal progress found (result is null)');
        return null;
      }

      final goalProgress = GoalProgress.fromJson(result);
      debugPrint('✅ Goal progress fetched: ${goalProgress.goal.goalName}');

      return goalProgress;

    } on DioException catch (e) {
      // ✅ Handle 400 error specifically (no goal exists)
      if (e.response?.statusCode == 400) {
        debugPrint('⚠️ No goal found (400 error)');

        // Try to parse error message
        try {
          final data = e.response!.data is String
              ? jsonDecode(e.response!.data)
              : e.response!.data;
          debugPrint('⚠️ Error message: ${data['message']}');
        } catch (_) {
          debugPrint('⚠️ Could not parse error response');
        }

        return null; // ✅ Return null instead of throwing
      }

      // ✅ Handle other errors
      debugPrint('❌ fetchGoalProgress DioException:');
      debugPrint('  Status code: ${e.response?.statusCode}');
      debugPrint('  Response: ${e.response?.data}');
      return null;

    } catch (e, stack) {
      debugPrint('❌ fetchGoalProgress unexpected error: $e');
      debugPrintStack(stackTrace: stack);
      return null;
    }
  }

  /// 🔥 NEW: Fetch all goals (history)
  static Future<List<GoalProgress>> fetchAllGoals() async {
    try {
      debugPrint('🔵 ============================================');
      debugPrint('🔵 Fetching all goals...');

      final dio = DioClient.dio;
      final response = await dio.get('/goal');

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        debugPrint('❌ API error: ${data['message']}');
        throw Exception(data['message'] ?? 'Failed to fetch goals');
      }

      final List result = data['result'] ?? [];
      debugPrint('🔵 Found ${result.length} goals');

      if (result.isEmpty) {
        debugPrint('⚠️ No goals found');
        return [];
      }

      final List<GoalProgress> goals = [];
      for (var i = 0; i < result.length; i++) {
        try {
          final goalProgress = GoalProgress.fromJson(result[i]);
          goals.add(goalProgress);
          debugPrint('  ✓ Goal ${i + 1}: ${goalProgress.goal.goalName} (${goalProgress.goal.status})');
        } catch (e) {
          debugPrint('  ⚠️ Failed to parse goal #$i: $e');
        }
      }

      debugPrint('✅ Successfully loaded ${goals.length} goals');
      debugPrint('🔵 ============================================');

      return goals;

    } on DioException catch (e) {
      debugPrint('❌ fetchAllGoals DioException:');
      debugPrint('  Status code: ${e.response?.statusCode}');
      debugPrint('  Response: ${e.response?.data}');

      // Return empty list instead of throwing for better UX
      return [];

    } catch (e, stack) {
      debugPrint('❌ fetchAllGoals error: $e');
      debugPrintStack(stackTrace: stack);
      return [];
    }
  }

  /// Create new goal
  static Future<void> createGoal(GoalRequest request) async {
    try {
      debugPrint('🔵 ============================================');
      debugPrint('🔵 Creating new goal...');
      debugPrint('🔵 ============================================');

      final dio = DioClient.dio;

      final response = await dio.post(
        '/goal',
        data: request.toJson(),
      );

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Create goal failed');
      }

      debugPrint('✅ Goal created successfully');

    } on DioException catch (e) {
      debugPrint('❌ createGoal DioException');
      debugPrint('  Status: ${e.response?.statusCode}');
      debugPrint('  Body: ${e.response?.data}');
      rethrow;
    }
  }

  /// Update existing goal
  static Future<GoalProgress?> updateGoal(int goalId, GoalRequest request) async {
    try {
      debugPrint('🔵 Updating goal $goalId...');

      final dio = DioClient.dio;

      final response = await dio.put(
        '/goal/$goalId',
        data: request.toJson(),
      );

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to update goal');
      }

      debugPrint('✅ Goal updated successfully');
      return null;

    } catch (e, stack) {
      debugPrint('❌ updateGoal error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Delete goal
  static Future<void> deleteGoal(int goalId) async {
    try {
      debugPrint('🔵 Deleting goal $goalId...');

      final dio = DioClient.dio;

      final response = await dio.delete('/goal/$goalId');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to delete goal');
      }

      debugPrint('✅ Goal deleted successfully');

    } catch (e, stack) {
      debugPrint('❌ deleteGoal error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }
}