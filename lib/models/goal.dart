// lib/models/goal.dart

class Goal {
  final int id;
  final String goalName;
  final double? targetWeight;
  final double? targetBodyFatPercentage;
  final double? targetMuscleMass;
  final int? targetWorkoutSessionsPerWeek;
  final int? targetCaloriesPerDay;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String notes;

  Goal({
    required this.id,
    required this.goalName,
    this.targetWeight,
    this.targetBodyFatPercentage,
    this.targetMuscleMass,
    this.targetWorkoutSessionsPerWeek,
    this.targetCaloriesPerDay,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.notes,
  });

  // ✅ Computed property cho goalType
  String get goalType {
    if (targetWeight != null) return 'Weight';
    if (targetBodyFatPercentage != null) return 'Body Fat';
    if (targetMuscleMass != null) return 'Muscle';
    return 'General';
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as int,
      goalName: json['goalName'] as String,
      targetWeight: json['targetWeight'] != null
          ? (json['targetWeight'] as num).toDouble()
          : null,
      targetBodyFatPercentage: json['targetBodyFatPercentage'] != null
          ? (json['targetBodyFatPercentage'] as num).toDouble()
          : null,
      targetMuscleMass: json['targetMuscleMass'] != null
          ? (json['targetMuscleMass'] as num).toDouble()
          : null,
      targetWorkoutSessionsPerWeek: json['targetWorkoutSessionsPerWeek'] as int?,
      targetCaloriesPerDay: json['targetCaloriesPerDay'] as int?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalName': goalName,
      'targetWeight': targetWeight,
      'targetBodyFatPercentage': targetBodyFatPercentage,
      'targetMuscleMass': targetMuscleMass,
      'targetWorkoutSessionsPerWeek': targetWorkoutSessionsPerWeek,
      'targetCaloriesPerDay': targetCaloriesPerDay,
      'startDate': startDate.toIso8601String().split('T')[0],
      'endDate': endDate.toIso8601String().split('T')[0],
      'status': status,
      'notes': notes,
    };
  }
}