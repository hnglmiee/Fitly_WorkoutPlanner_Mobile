// lib/models/workout_exercise.dart

class WorkoutExercise {
  final int workoutExerciseId;
  final int planId;
  final String planTitle;
  final int exerciseId;
  final String exerciseName;
  final int sets;
  final int reps;
  final double? weight;
  final String? comments;

  WorkoutExercise({
    required this.workoutExerciseId,
    required this.planId,
    required this.planTitle,
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    this.weight,
    this.comments,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      workoutExerciseId: json['workoutExerciseId'] as int,
      planId: json['planId'] as int,
      planTitle: json['planTitle'] as String,
      exerciseId: json['exerciseId'] as int,
      exerciseName: json['exerciseName'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      weight: json['weight'] != null
          ? (json['weight'] is int
          ? (json['weight'] as int).toDouble()
          : json['weight'] as double)
          : null,
      comments: json['comments'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutExerciseId': workoutExerciseId,
      'planId': planId,
      'planTitle': planTitle,
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'comments': comments,
    };
  }

  @override
  String toString() {
    return 'WorkoutExercise(id: $workoutExerciseId, exercise: $exerciseName, sets: $sets, reps: $reps, weight: $weight)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutExercise &&
        other.workoutExerciseId == workoutExerciseId;
  }

  @override
  int get hashCode => workoutExerciseId.hashCode;
}