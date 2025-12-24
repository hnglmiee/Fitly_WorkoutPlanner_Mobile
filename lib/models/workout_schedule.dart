class WorkoutSchedule {
  final int id;
  final String planName;
  final DateTime scheduledDate;
  final String status;

  WorkoutSchedule({
    required this.id,
    required this.planName,
    required this.scheduledDate,
    required this.status,
  });

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) {
    try {
      // ✅ Handle null and different date formats
      final dateStr = json['scheduledDate'] as String?;

      if (dateStr == null || dateStr.isEmpty) {
        throw Exception('scheduledDate is null or empty');
      }

      DateTime parsedDate;

      // ✅ Try different date formats
      if (dateStr.contains('T')) {
        // ISO format: "2024-12-25T00:00:00Z"
        parsedDate = DateTime.parse(dateStr);
      } else if (dateStr.contains('-')) {
        // Simple format: "2024-12-25"
        final parts = dateStr.split('-');
        parsedDate = DateTime(
          int.parse(parts[0]), // year
          int.parse(parts[1]), // month
          int.parse(parts[2]), // day
        );
      } else {
        throw Exception('Unknown date format: $dateStr');
      }

      return WorkoutSchedule(
        id: json['id'] ?? 0,
        planName: json['planName'] ?? '',
        status: json['status'] ?? 'upcoming',
        scheduledDate: parsedDate,
      );
    } catch (e) {
      rethrow;
    }
  }
}
