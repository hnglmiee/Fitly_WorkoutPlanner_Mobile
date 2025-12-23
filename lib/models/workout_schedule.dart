class WorkoutSchedule {
  final String planName;
  final DateTime scheduledDate;
  final String status;

  WorkoutSchedule({
    required this.planName,
    required this.scheduledDate,
    required this.status,
  });

  factory WorkoutSchedule.fromJson(Map<String, dynamic> json) {
    final parts = json['scheduledDate'].split('-');

    return WorkoutSchedule(
      planName: json['planName'],
      status: json['status'],
      scheduledDate: DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      ),
    );
  }
}
