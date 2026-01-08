// lib/models/exercise_log.dart

class ExerciseLog {
  final int sets;
  final int reps;
  final double weight;
  final String notes;
  final int? logId; // ID từ server sau khi save
  final DateTime? loggedAt;

  ExerciseLog({
    required this.sets,
    required this.reps,
    required this.weight,
    this.notes = '',
    this.logId,
    this.loggedAt,
  });

  ExerciseLog copyWith({
    int? sets,
    int? reps,
    double? weight,
    String? notes,
    int? logId,
    DateTime? loggedAt,
  }) {
    return ExerciseLog(
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      notes: notes ?? this.notes,
      logId: logId ?? this.logId,
      loggedAt: loggedAt ?? this.loggedAt,
    );
  }

  @override
  String toString() {
    return 'ExerciseLog(sets: $sets, reps: $reps, weight: $weight, logId: $logId)';
  }
}