// lib/services/workout_log_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../network/dio_client.dart';

class WorkoutLogService {
  /// Log workout exercise
  static Future<WorkoutLogResponse> logWorkout({
    required int scheduleId,
    required int exerciseId,
    required int actualSets,
    required int actualReps,
    required double actualWeight,
    String notes = '',
  }) async {
    try {
      debugPrint('🔵 Logging workout...');
      debugPrint('  scheduleId: $scheduleId');
      debugPrint('  exerciseId: $exerciseId');
      debugPrint('  sets: $actualSets, reps: $actualReps, weight: $actualWeight');

      final dio = DioClient.dio;

      // ✅ Gửi đầy đủ theo format backend expect
      final requestData = {
        'scheduleId': scheduleId,
        'exerciseId': exerciseId,
        'actualSets': actualSets,
        'actualReps': actualReps,
        'actualWeight': actualWeight.toInt(),
        'notes': notes,
        'loggedAt': DateTime.now().toUtc().toIso8601String(),
      };

      debugPrint('🔵 Request data: $requestData');

      final response = await dio.post(
        '/workout-logs',
        data: requestData,
      );

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final logResponse = WorkoutLogResponse.fromJson(data['result']);
      debugPrint('✅ Workout logged successfully: ${logResponse.toString()}');

      return logResponse;
    } on DioException catch (e) {
      debugPrint('❌ logWorkout DioException:');
      debugPrint('  Status code: ${e.response?.statusCode}');
      debugPrint('  Response body: ${e.response?.data}');
      debugPrint('  Request sent: ${e.requestOptions.data}');
      debugPrint('  URL: ${e.requestOptions.path}');

      // Extract error message from response
      String errorMessage = 'Failed to log workout';
      if (e.response?.data != null) {
        try {
          final responseData = e.response!.data is String
              ? jsonDecode(e.response!.data)
              : e.response!.data;
          errorMessage = responseData['message'] ?? errorMessage;

          // Log validation errors if exist
          if (responseData['errors'] != null) {
            debugPrint('  Validation errors: ${responseData['errors']}');
          }
        } catch (_) {
          errorMessage = e.response!.data.toString();
        }
      }

      throw Exception(errorMessage);
    } catch (e, stack) {
      debugPrint('❌ logWorkout error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Get all workout logs (optional - nếu backend support)
  static Future<List<WorkoutLogResponse>> fetchWorkoutLogs({
    int? scheduleId,
  }) async {
    try {
      debugPrint('🔵 Fetching workout logs...');

      final dio = DioClient.dio;

      final endpoint = scheduleId != null
          ? '/workout-logs?scheduleId=$scheduleId'
          : '/workout-logs';

      final response = await dio.get(endpoint);

      debugPrint('🔵 Response status: ${response.statusCode}');
      debugPrint('🔵 Response data: ${response.data}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Logs list length: ${list.length}');

      if (list.isEmpty) {
        debugPrint('⚠️ No workout logs found');
        return [];
      }

      final logs = list.map((e) {
        return WorkoutLogResponse.fromJson(e as Map<String, dynamic>);
      }).toList();

      debugPrint('✅ Successfully fetched ${logs.length} logs');
      return logs;
    } catch (e, stack) {
      debugPrint('❌ fetchWorkoutLogs error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Update workout log (optional - nếu backend support)
  static Future<WorkoutLogResponse> updateWorkoutLog({
    required int logId,
    required int scheduleId,
    required int exerciseId,
    required int actualSets,
    required int actualReps,
    required double actualWeight,
    String notes = '',
  }) async {
    try {
      debugPrint('🔵 Updating workout log $logId...');

      final dio = DioClient.dio;

      final requestData = {
        'scheduleId': scheduleId,
        'exerciseId': exerciseId,
        'actualSets': actualSets,
        'actualReps': actualReps,
        'actualWeight': actualWeight,
        'notes': notes,
      };

      final response = await dio.put(
        '/workout-logs/$logId',
        data: requestData,
      );

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to update log');
      }

      debugPrint('✅ Workout log updated successfully');
      return WorkoutLogResponse.fromJson(data['result']);
    } catch (e, stack) {
      debugPrint('❌ updateWorkoutLog error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Delete workout log (optional - nếu backend support)
  static Future<void> deleteWorkoutLog(int logId) async {
    try {
      debugPrint('🔵 Deleting workout log $logId...');

      final dio = DioClient.dio;
      final response = await dio.delete('/workout-logs/$logId');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        throw Exception(data['message'] ?? 'Failed to delete log');
      }

      debugPrint('✅ Workout log deleted successfully');
    } catch (e, stack) {
      debugPrint('❌ deleteWorkoutLog error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }
  /// Get workout logs by scheduleId and map by exerciseId (get LATEST log per exercise)
  static Future<Map<int, WorkoutLogResponse>> fetchLogsBySchedule(int scheduleId) async {
    try {
      debugPrint('🔵 ============================================');
      debugPrint('🔵 fetchLogsBySchedule called');
      debugPrint('🔵 Schedule ID: $scheduleId');
      debugPrint('🔵 ============================================');

      final dio = DioClient.dio;
      final endpoint = '/workout-logs/schedule/$scheduleId';
      debugPrint('🔵 GET Request to: $endpoint');

      final response = await dio.get(endpoint);

      debugPrint('🔵 Response status: ${response.statusCode}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      debugPrint('🔵 Response code: ${data['code']}');
      debugPrint('🔵 Response message: ${data['message']}');

      if (data['code'] != 1000) {
        debugPrint('❌ API returned error code: ${data['code']}');
        return {};
      }

      final List list = data['result'] ?? [];
      debugPrint('🔵 Found ${list.length} logs for schedule $scheduleId');

      if (list.isEmpty) {
        debugPrint('⚠️ No logs found for schedule $scheduleId');
        return {};
      }

      // ✅ Parse all logs
      final List<WorkoutLogResponse> allLogs = [];
      for (var i = 0; i < list.length; i++) {
        try {
          final log = WorkoutLogResponse.fromJson(list[i]);
          allLogs.add(log);
        } catch (e) {
          debugPrint('⚠️ Failed to parse log #$i: $e');
        }
      }

      debugPrint('✅ Successfully parsed ${allLogs.length} logs');

      // ✅ SIMPLIFIED: Keep only FIRST log per exerciseId (since API returns sorted DESC)
      final Map<int, WorkoutLogResponse> logsMap = {};

      for (var log in allLogs) {
        final exerciseId = log.exerciseId;

        // ✅ Only add if this exerciseId hasn't been seen yet
        if (!logsMap.containsKey(exerciseId)) {
          logsMap[exerciseId] = log;

          debugPrint('📝 Latest log for exerciseId $exerciseId:');
          debugPrint('   - Exercise: ${log.exerciseName}');
          debugPrint('   - Sets: ${log.actualSets}, Reps: ${log.actualReps}, Weight: ${log.actualWeight}kg');
          debugPrint('   - Notes: ${log.notes}');
          debugPrint('   - Logged at: ${log.loggedAt}');
        } else {
          debugPrint('⏭️ Skipping duplicate exerciseId $exerciseId (older log from ${log.loggedAt})');
        }
      }

      debugPrint('🔵 ============================================');
      debugPrint('✅ Total UNIQUE exercises with logs: ${logsMap.length}');
      debugPrint('✅ Exercise IDs: ${logsMap.keys.toList()}');

      // Summary
      for (var entry in logsMap.entries) {
        debugPrint('   📊 exerciseId ${entry.key}: ${entry.value.exerciseName}');
        debugPrint('      → ${entry.value.actualSets} sets × ${entry.value.actualReps} reps @ ${entry.value.actualWeight}kg');
        debugPrint('      → Logged at: ${entry.value.loggedAt}');
      }

      debugPrint('🔵 ============================================');

      return logsMap;

    } catch (e, stack) {
      debugPrint('❌ ============================================');
      debugPrint('❌ fetchLogsBySchedule CRITICAL ERROR');
      debugPrint('❌ Error: $e');
      debugPrint('❌ ============================================');
      debugPrintStack(stackTrace: stack);
      return {};
    }
  }
}