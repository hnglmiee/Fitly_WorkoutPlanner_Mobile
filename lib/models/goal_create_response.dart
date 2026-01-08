class GoalCreateResponse {
  final String goalName;
  final double targetWeight;
  final double targetBodyFatPercentage;
  final double targetMuscleMass;
  final int targetWorkoutSessionsPerWeek;
  final int targetCaloriesPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? notes;

  GoalCreateResponse({
    required this.goalName,
    required this.targetWeight,
    required this.targetBodyFatPercentage,
    required this.targetMuscleMass,
    required this.targetWorkoutSessionsPerWeek,
    required this.targetCaloriesPerDay,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.notes,
  });

  factory GoalCreateResponse.fromJson(Map<String, dynamic> json) {
    return GoalCreateResponse(
      goalName: json['goalName'],
      targetWeight: (json['targetWeight'] as num).toDouble(),
      targetBodyFatPercentage:
      (json['targetBodyFatPercentage'] as num).toDouble(),
      targetMuscleMass: (json['targetMuscleMass'] as num).toDouble(),
      targetWorkoutSessionsPerWeek:
      json['targetWorkoutSessionsPerWeek'],
      targetCaloriesPerDay: json['targetCaloriesPerDay'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: json['status'],
      notes: json['notes'],
    );
  }
}
