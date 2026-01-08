// lib/models/goal_request.dart

class GoalRequest {
  final String goalName;
  final double targetWeight;
  final double targetBodyFatPercentage;
  final double targetMuscleMass;
  final int targetWorkoutSessionsPerWeek;
  final int targetCaloriesPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String notes;

  GoalRequest({
    required this.goalName,
    required this.targetWeight,
    required this.targetBodyFatPercentage,
    required this.targetMuscleMass,
    required this.targetWorkoutSessionsPerWeek,
    required this.targetCaloriesPerDay,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.notes = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
      'targetWeight': targetWeight,
      'targetBodyFatPercentage': targetBodyFatPercentage,
      'targetMuscleMass': targetMuscleMass,
      'targetWorkoutSessionsPerWeek': targetWorkoutSessionsPerWeek,
      'targetCaloriesPerDay': targetCaloriesPerDay,
      'startDate': _formatDate(startDate),
      'endDate': _formatDate(endDate),
      'status': status,
      'notes': notes,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}