// lib/models/workout_log.dart

class WorkoutLogResponse {
  final int id;
  final int scheduleId;
  final int exerciseId;
  final String exerciseName;
  final int actualSets;
  final int actualReps;
  final double actualWeight;
  final String notes;
  final DateTime loggedAt;

  WorkoutLogResponse({
    required this.id,
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
    try {
      // 🔥 DEBUG: Print raw JSON to see what's null
      print('🔥 Parsing WorkoutLogResponse from JSON:');
      print('   id: ${json['id']} (${json['id'].runtimeType})');
      print('   scheduleId: ${json['scheduleId']} (${json['scheduleId'].runtimeType})');
      print('   exerciseId: ${json['exerciseId']} (${json['exerciseId'].runtimeType})');
      print('   exerciseName: ${json['exerciseName']}');
      print('   actualSets: ${json['actualSets']}');
      print('   actualReps: ${json['actualReps']}');
      print('   actualWeight: ${json['actualWeight']}');
      print('   notes: ${json['notes']}');
      print('   loggedAt: ${json['loggedAt']}');

      return WorkoutLogResponse(
        id: _parseInt(json['id']),
        scheduleId: _parseInt(json['scheduleId']),
        exerciseId: _parseInt(json['exerciseId']),
        exerciseName: json['exerciseName'] as String? ?? 'Unknown',
        actualSets: _parseInt(json['actualSets']),
        actualReps: _parseInt(json['actualReps']),
        actualWeight: _parseDouble(json['actualWeight']),
        notes: json['notes'] as String? ?? '',
        loggedAt: DateTime.parse(json['loggedAt'] as String),
      );
    } catch (e, stack) {
      print('❌ Error parsing WorkoutLogResponse: $e');
      print('   JSON: $json');
      print('   Stack: $stack');
      rethrow;
    }
  }

  // Helper to safely parse int
  static int _parseInt(dynamic value) {
    if (value == null) {
      throw Exception('Required int field is null');
    }
    if (value is int) return value;
    if (value is String) return int.parse(value);
    if (value is num) return value.toInt();
    throw Exception('Cannot parse $value to int');
  }

  // Helper to safely parse double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    if (value is num) return value.toDouble();
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'exerciseId': exerciseId,
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
    return 'WorkoutLogResponse(id: $id, scheduleId: $scheduleId, exerciseId: $exerciseId, '
        'exerciseName: $exerciseName, sets: $actualSets, reps: $actualReps, '
        'weight: ${actualWeight}kg, notes: "$notes", loggedAt: $loggedAt)';
  }

  WorkoutLogResponse copyWith({
    int? id,
    int? scheduleId,
    int? exerciseId,
    String? exerciseName,
    int? actualSets,
    int? actualReps,
    double? actualWeight,
    String? notes,
    DateTime? loggedAt,
  }) {
    return WorkoutLogResponse(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      actualSets: actualSets ?? this.actualSets,
      actualReps: actualReps ?? this.actualReps,
      actualWeight: actualWeight ?? this.actualWeight,
      notes: notes ?? this.notes,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }
}