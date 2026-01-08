// lib/models/workout_schedule.dart

/// Model đơn giản - chỉ cần planName
class WorkoutSchedule {
  final int id;
  final int? planId;      // 🔥 THÊM FIELD NÀY
  final String planName;
  final DateTime scheduledDate;
  final String status;
  final DateTime? scheduledTime;

  WorkoutSchedule({
    required this.id,
    this.planId,          // 🔥 THÊM
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
      if (dateStr.contains('T')) {
        parsedDate = DateTime.parse(dateStr);
      } else if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        parsedDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } else {
        throw Exception('Unknown date format: $dateStr');
      }

      // Parse scheduled time (optional)
      DateTime? parsedTime;
      final timeStr = json['scheduledTime'] as String?;
      if (timeStr != null && timeStr.isNotEmpty) {
        try {
          parsedTime = DateTime.parse('1970-01-01 $timeStr');
        } catch (e) {
          parsedTime = null;
        }
      }

      return WorkoutSchedule(
        id: json['id'] ?? 0,
        planId: json['planId'],  // 🔥 PARSE PLAN ID
        planName: json['planName'] ?? 'Unnamed Plan',
        status: json['status'] ?? 'Pending',
        scheduledDate: parsedDate,
        scheduledTime: parsedTime,
      );
    } catch (e) {
      print('❌ Error parsing WorkoutSchedule: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'planId': planId,    // 🔥 INCLUDE
      'planName': planName,
      'scheduledDate': scheduledDate.toIso8601String().split('T')[0],
      'status': status,
      if (scheduledTime != null)
        'scheduledTime': '${scheduledTime!.hour.toString().padLeft(2, '0')}:'
            '${scheduledTime!.minute.toString().padLeft(2, '0')}:00',
    };
  }
}