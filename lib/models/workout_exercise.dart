// models/workout_exercise.dart

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
      workoutExerciseId: json['workoutExerciseId'],
      planId: json['planId'],
      planTitle: json['planTitle'],
      exerciseId: json['exerciseId'],
      exerciseName: json['exerciseName'],
      sets: json['sets'],
      reps: json['reps'],
      weight: json['weight']?.toDouble(),
      comments: json['comments'],
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
    return 'WorkoutExercise(id: $workoutExerciseId, planId: $planId, name: $exerciseName)';
  }
}
