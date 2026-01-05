// lib/models/workout_schedule.dart

import 'package:intl/intl.dart';

class WorkoutSchedule {
  final int id;
  final int planId; // ✅ THÊM FIELD NÀY
  final String planName;
  final DateTime scheduledDate;
  final String status;
  final DateTime? scheduledTime;

  WorkoutSchedule({
    required this.id,
    required this.planId, // ✅ THÊM VÀO CONSTRUCTOR
    required this.planName,
    required this.scheduledDate,
    required this.status,
    this.scheduledTime,
  });

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) {
    try {
      // Parse scheduled date
      final dateStr = json['scheduledDate'] as String?;
      if (dateStr == null || dateStr.isEmpty) {
        throw Exception('scheduledDate is null or empty');
      }

      DateTime parsedDate;
      try {
        if (dateStr.contains('T')) {
          parsedDate = DateTime.parse(dateStr);
        } else if (dateStr.contains('-')) {
          final parts = dateStr.split('-');
          if (parts.length != 3) {
            throw Exception('Invalid date format: $dateStr');
          }
          parsedDate = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        } else {
          parsedDate = DateFormat('yyyy-MM-dd').parse(dateStr);
        }
      } catch (e) {
        throw Exception('Failed to parse scheduledDate: $dateStr - Error: $e');
      }

      // Parse scheduled time (optional)
      DateTime? parsedTime;
      final timeStr = json['scheduledTime'] as String?;
      if (timeStr != null && timeStr.isNotEmpty) {
        try {
          if (timeStr.contains('T')) {
            parsedTime = DateTime.parse(timeStr);
          } else {
            final timeParts = timeStr.split(':');
            if (timeParts.length >= 2) {
              final hour = int.parse(timeParts[0]);
              final minute = int.parse(timeParts[1]);
              final second = timeParts.length > 2 ? int.parse(timeParts[2]) : 0;

              parsedTime = DateTime(
                parsedDate.year,
                parsedDate.month,
                parsedDate.day,
                hour,
                minute,
                second,
              );
            }
          }
        } catch (e) {
          print('⚠️ Warning: Could not parse scheduledTime: $timeStr - $e');
          parsedTime = null;
        }
      }

      return WorkoutSchedule(
        id: json['id'] as int? ?? 0,
        planId: json['planId'] as int? ?? 0, // ✅ PARSE planId
        planName: json['planName'] as String? ?? 'Unnamed Plan',
        status: json['status'] as String? ?? 'Pending',
        scheduledDate: parsedDate,
        scheduledTime: parsedTime,
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing WorkoutSchedule from JSON: $json');
      print('❌ Error: $e');
      print('❌ StackTrace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId, // ✅ THÊM VÀO JSON
      'planName': planName,
      'scheduledDate': scheduledDate.toIso8601String().split('T')[0],
      'status': status,
      if (scheduledTime != null)
        'scheduledTime':
        '${scheduledTime!.hour.toString().padLeft(2, '0')}:'
            '${scheduledTime!.minute.toString().padLeft(2, '0')}:'
            '${scheduledTime!.second.toString().padLeft(2, '0')}',
    };
  }

  @override
  String toString() {
    return 'WorkoutSchedule(id: $id, planId: $planId, planName: $planName, '
        'scheduledDate: $scheduledDate, status: $status, '
        'scheduledTime: $scheduledTime)';
  }
}