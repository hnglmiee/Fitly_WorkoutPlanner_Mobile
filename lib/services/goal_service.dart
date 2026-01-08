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

  /// Create new goal
  // static Future<GoalProgress?> createGoal(GoalRequest request) async {
  //   try {
  //     debugPrint('🔵 ============================================');
  //     debugPrint('🔵 Creating new goal...');
  //     debugPrint('  Goal name: ${request.goalName}');
  //     debugPrint('  Target weight: ${request.targetWeight}kg');
  //     debugPrint('  Target body fat: ${request.targetBodyFatPercentage}%');
  //     debugPrint('  Target muscle mass: ${request.targetMuscleMass}%');
  //     debugPrint('  Workout sessions/week: ${request.targetWorkoutSessionsPerWeek}');
  //     debugPrint('  Calories/day: ${request.targetCaloriesPerDay}');
  //     debugPrint('  Start date: ${request.startDate}');
  //     debugPrint('  End date: ${request.endDate}');
  //     debugPrint('  Status: ${request.status}');
  //     debugPrint('🔵 ============================================');
  //
  //     final dio = DioClient.dio;
  //
  //     final requestData = request.toJson();
  //     debugPrint('🔵 Request payload: ${jsonEncode(requestData)}');
  //
  //     final response = await dio.post(
  //       '/goal',
  //       data: requestData,
  //     );
  //
  //     debugPrint('🔵 Response status: ${response.statusCode}');
  //     debugPrint('🔵 Response data: ${response.data}');
  //
  //     final data = response.data is String
  //         ? jsonDecode(response.data)
  //         : response.data;
  //
  //     if (data['code'] != 1000) {
  //       final message = data['message'] ?? 'Unknown error';
  //       debugPrint('❌ API error code: ${data['code']}');
  //       debugPrint('❌ API error message: $message');
  //       throw Exception('API Error: $message');
  //     }
  //
  //     // Parse response as GoalProgress
  //     final result = data['result'];
  //     if (result == null) {
  //       throw Exception('No result in response');
  //     }
  //
  //     final goalProgress = GoalProgress.fromJson(result);
  //     debugPrint('🔵 ============================================');
  //     debugPrint('✅ Goal created successfully!');
  //     debugPrint('  Goal name: ${goalProgress.goal.goalName}');
  //     debugPrint('  Status: ${goalProgress.status}');
  //     debugPrint('🔵 ============================================');
  //
  //     return goalProgress;
  //
  //   } on DioException catch (e) {
  //     debugPrint('❌ ============================================');
  //     debugPrint('❌ createGoal DioException');
  //     debugPrint('  Status code: ${e.response?.statusCode}');
  //     debugPrint('  Response body: ${e.response?.data}');
  //     debugPrint('  Request data: ${e.requestOptions.data}');
  //     debugPrint('  URL: ${e.requestOptions.path}');
  //     debugPrint('❌ ============================================');
  //
  //     String errorMessage = 'Failed to create goal';
  //     if (e.response?.data != null) {
  //       try {
  //         final responseData = e.response!.data is String
  //             ? jsonDecode(e.response!.data)
  //             : e.response!.data;
  //         errorMessage = responseData['message'] ?? errorMessage;
  //
  //         // Log validation errors if exist
  //         if (responseData['errors'] != null) {
  //           debugPrint('  Validation errors: ${responseData['errors']}');
  //         }
  //       } catch (_) {
  //         errorMessage = e.response!.data.toString();
  //       }
  //     }
  //
  //     throw Exception(errorMessage);
  //
  //   } catch (e, stack) {
  //     debugPrint('❌ ============================================');
  //     debugPrint('❌ createGoal unexpected error: $e');
  //     debugPrint('❌ ============================================');
  //     debugPrintStack(stackTrace: stack);
  //     rethrow;
  //   }
  // }

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

      // ✅ KHÔNG parse GoalProgress ở đây
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

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to update goal');
      }

      final result = data['result'];
      if (result == null) return null;

      debugPrint('✅ Goal updated successfully');
      return GoalProgress.fromJson(result);

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