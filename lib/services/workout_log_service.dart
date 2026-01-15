// lib/services/workout_log_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/workout_log.dart';
import '../network/dio_client.dart';

class WorkoutLogService {
  /// 🔥 WORKAROUND: Log workout - ignore POST response, refetch from GET
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

      // 🔥 WORKAROUND: Call POST but don't parse response
      final response = await dio.post(
        '/workout-logs',
        data: requestData,
      );

      debugPrint('🔵 Response status: ${response.statusCode}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      debugPrint('✅ Workout logged to database (ignoring response parsing)');

      // 🔥 WORKAROUND: Refetch from GET endpoint to get complete data
      debugPrint('🔵 Refetching from GET endpoint...');
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay for DB sync

      final logs = await fetchLogsBySchedule(scheduleId);

      if (logs.containsKey(exerciseId)) {
        final log = logs[exerciseId]!;
        debugPrint('✅ Fetched complete log data: ID=${log.id}, ExerciseId=${log.exerciseId}');
        return log;
      } else {
        throw Exception('Could not find created log');
      }
    } on DioException catch (e) {
      debugPrint('❌ logWorkout DioException:');
      debugPrint('  Status code: ${e.response?.statusCode}');
      debugPrint('  Response body: ${e.response?.data}');

      String errorMessage = 'Failed to log workout';
      if (e.response?.data != null) {
        try {
          final responseData = e.response!.data is String
              ? jsonDecode(e.response!.data)
              : e.response!.data;
          errorMessage = responseData['message'] ?? errorMessage;
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

  /// Get all workout logs
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

  /// 🔥 WORKAROUND: Update workout log - ignore PUT response, refetch from GET
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
      debugPrint('🔵 ============================================');
      debugPrint('🔵 Updating workout log $logId...');
      debugPrint('  URL: /workout-logs/$logId');

      final dio = DioClient.dio;

      final requestData = {
        'scheduleId': scheduleId,
        'exerciseId': exerciseId,
        'actualSets': actualSets,
        'actualReps': actualReps,
        'actualWeight': actualWeight.toInt(),
        'notes': notes,
        'loggedAt': DateTime.now().toUtc().toIso8601String(),
      };

      debugPrint('🔵 Request body: $requestData');

      // 🔥 WORKAROUND: Call PUT but don't parse response
      final response = await dio.put(
        '/workout-logs/$logId',
        data: requestData,
      );

      debugPrint('🔵 Response status: ${response.statusCode}');

      final data =
      response.data is String ? jsonDecode(response.data) : response.data;

      if (data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      debugPrint('✅ Workout log updated in database (ignoring response parsing)');

      // 🔥 WORKAROUND: Refetch from GET endpoint
      debugPrint('🔵 Refetching from GET endpoint...');
      await Future.delayed(const Duration(milliseconds: 500)); // Small delay for DB sync

      final logs = await fetchLogsBySchedule(scheduleId);

      if (logs.containsKey(exerciseId)) {
        final log = logs[exerciseId]!;
        debugPrint('✅ Fetched updated log data: ID=${log.id}, ExerciseId=${log.exerciseId}');
        debugPrint('🔵 ============================================');
        return log;
      } else {
        throw Exception('Could not find updated log');
      }
    } on DioException catch (e) {
      debugPrint('❌ updateWorkoutLog DioException:');
      debugPrint('  Status code: ${e.response?.statusCode}');
      debugPrint('  Response body: ${e.response?.data}');

      String errorMessage = 'Failed to update workout log';
      if (e.response?.data != null) {
        try {
          final responseData = e.response!.data is String
              ? jsonDecode(e.response!.data)
              : e.response!.data;
          errorMessage = responseData['message'] ?? errorMessage;
        } catch (_) {
          errorMessage = e.response!.data.toString();
        }
      }

      throw Exception(errorMessage);
    } catch (e, stack) {
      debugPrint('❌ updateWorkoutLog error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// Delete workout log
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

  /// Get workout logs by scheduleId - THIS WORKS PERFECTLY
  static Future<Map<int, WorkoutLogResponse>> fetchLogsBySchedule(int scheduleId) async {
    try {
      debugPrint('🔵 ============================================');
      debugPrint('🔵 fetchLogsBySchedule called');
      debugPrint('🔵 Schedule ID: $scheduleId');

      final dio = DioClient.dio;
      final endpoint = '/workout-logs/schedule/$scheduleId';
      debugPrint('🔵 GET Request to: $endpoint');

      final response = await dio.get(endpoint);

      debugPrint('🔵 Response status: ${response.statusCode}');

      final data = response.data is String ? jsonDecode(response.data) : response.data;

      debugPrint('🔵 Response code: ${data['code']}');

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

      final Map<int, WorkoutLogResponse> logsMap = {};

      for (var log in allLogs) {
        final exerciseId = log.exerciseId;

        if (!logsMap.containsKey(exerciseId)) {
          logsMap[exerciseId] = log;
          debugPrint('📝 Latest log for exerciseId $exerciseId: ${log.exerciseName} (ID: ${log.id})');
        }
      }

      debugPrint('✅ Total UNIQUE exercises with logs: ${logsMap.length}');
      debugPrint('🔵 ============================================');

      return logsMap;

    } catch (e, stack) {
      debugPrint('❌ fetchLogsBySchedule error: $e');
      debugPrintStack(stackTrace: stack);
      return {};
    }
  }
}