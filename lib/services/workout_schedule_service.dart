// lib/services/workout_schedule_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/workout_schedule.dart';
import '../network/dio_client.dart';
import 'package:intl/intl.dart';

class WorkoutScheduleService {
  /// 🔥 TẠO SCHEDULE CHO WORKOUT PLAN
  static Future<WorkoutSchedule> createSchedule({
    required int planId,
    required DateTime scheduledDate,
    DateTime? scheduledTime,
  }) async {
    try {
      final dateStr = DateFormat('yyyy-MM-dd').format(scheduledDate);
      final timeStr = scheduledTime != null
          ? DateFormat('HH:mm:ss').format(scheduledTime)
          : null;

      debugPrint('🔵 Creating schedule for plan $planId on $dateStr');

      final requestBody = {
        'planId': planId,
        'scheduledDate': dateStr,
        if (timeStr != null) 'scheduledTime': timeStr,
      };

      debugPrint('📤 Request body: ${jsonEncode(requestBody)}');

      final dio = DioClient.dio;
      final response = await dio.post(
        '/workout-schedules',
        data: requestBody,
      );

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != null && data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final scheduleData = data['result'] ?? data;
      debugPrint('✅ Schedule created successfully');

      return WorkoutSchedule.fromJson(scheduleData);
    } catch (e, stack) {
      debugPrint('❌ createSchedule error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// 🔥 LẤY TẤT CẢ SCHEDULES
  static Future<List<WorkoutSchedule>> getAllSchedules() async {
    try {
      debugPrint('🔵 Fetching all schedules...');

      final dio = DioClient.dio;
      final response = await dio.get('/workout-schedules/my-schedules');

      debugPrint('📥 Response status: ${response.statusCode}');
      debugPrint('📥 Response data: ${response.data}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != null && data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        debugPrint('❌ API error: $message');
        throw Exception('API Error: $message');
      }

      final List schedulesList = data['result'] ?? [];
      debugPrint('🔵 Schedules list length: ${schedulesList.length}');

      if (schedulesList.isEmpty) {
        debugPrint('⚠️ No schedules found');
        return [];
      }

      final schedules = schedulesList.map((e) {
        debugPrint('🔵 Parsing schedule: $e');
        return WorkoutSchedule.fromJson(e as Map<String, dynamic>);
      }).toList();

      debugPrint('✅ Successfully fetched ${schedules.length} schedules');
      return schedules;
    } catch (e, stack) {
      debugPrint('❌ getAllSchedules error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// 🔥 DELETE SCHEDULE
  static Future<void> deleteSchedule(int scheduleId) async {
    try {
      debugPrint('🔵 Deleting schedule $scheduleId');

      final dio = DioClient.dio;
      final response = await dio.delete('/workout-schedules/$scheduleId');

      debugPrint('📥 Response status: ${response.statusCode}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != null && data['code'] != 1000) {
        final message = data['message'] ?? 'Unknown error';
        throw Exception('API Error: $message');
      }

      debugPrint('✅ Schedule deleted successfully');
    } catch (e, stack) {
      debugPrint('❌ deleteSchedule error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  /// 🔥 UPDATE SCHEDULE STATUS
  static Future<void> updateScheduleStatus(
      int scheduleId,
      String status,
      ) async {
    try {
      debugPrint('🔵 Updating schedule $scheduleId to status: $status');

      final dio = DioClient.dio;
      final response = await dio.put(
        '/workout-schedules/$scheduleId',
        data: {'status': status},
      );

      debugPrint('📥 Response status: ${response.statusCode}');

      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      if (data['code'] != null && data['code'] != 1000) {
        throw Exception('API Error: ${data['message']}');
      }

      debugPrint('✅ Schedule status updated successfully');
    } catch (e, stack) {
      debugPrint('❌ updateScheduleStatus error: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }
}