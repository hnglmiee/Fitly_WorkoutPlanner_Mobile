// lib/models/workout_log_models.dart

/// Request model để log workout
class WorkoutLogRequest {
  final int scheduleId;
  final int exerciseId;
  final int actualSets;
  final int actualReps;
  final double actualWeight;
  final String notes;
  final DateTime loggedAt;

  WorkoutLogRequest({
    required this.scheduleId,
    required this.exerciseId,
    required this.actualSets,
    required this.actualReps,
    required this.actualWeight,
    required this.notes,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'exerciseId': exerciseId,
      'actualSets': actualSets,
      'actualReps': actualReps,
      'actualWeight': actualWeight,
      'notes': notes,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }
}

/// Response model từ API
class WorkoutLogResponse {
  final int scheduleId;
  final int exerciseId;
  final String exerciseName;
  final int actualSets;
  final int actualReps;
  final double actualWeight;
  final String notes;
  final DateTime loggedAt;

  WorkoutLogResponse({
    required this.scheduleId,
    required this.exerciseId,
    required this.exerciseName,
    required this.actualSets,
    required this.actualReps,
    required this.actualWeight,
    required this.notes,
    required this.loggedAt,
  });

  factory WorkoutLogResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutLogResponse(
      scheduleId: json['scheduleId'] as int,
      exerciseId: json['exerciseId'] as int,
      exerciseName: json['exerciseName'] as String,
      actualSets: json['actualSets'] as int,
      actualReps: json['actualReps'] as int,
      actualWeight: (json['actualWeight'] as num).toDouble(),
      notes: json['notes'] as String? ?? '',
      loggedAt: DateTime.parse(json['loggedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'exerciseName': exerciseName,
      'actualSets': actualSets,
      'actualReps': actualReps,
      'actualWeight': actualWeight,
      'notes': notes,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WorkoutLogResponse(scheduleId: $scheduleId, exerciseName: $exerciseName, sets: $actualSets, reps: $actualReps, weight: $actualWeight)';
  }
}