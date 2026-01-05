// lib/models/workout_plan.dart

class WorkoutPlan {
  final int id;
  final String title;
  final String notes;
  final List<Exercise>? exercises;
  final bool? everyDay;
  final List<String>? days;
  final String? reminder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.notes,
    this.exercises,
    this.everyDay,
    this.days,
    this.reminder,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      title: json['title'],
      notes: json['notes'] ?? '',
      exercises: json['exercises'] != null
          ? (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList()
          : null,
      everyDay: json['everyDay'],
      days: json['days'] != null ? List<String>.from(json['days']) : null,
      reminder: json['reminder'],
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
      json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'notes': notes,
      'exercises': exercises?.map((e) => e.toJson()).toList(),
      'everyDay': everyDay,
      'days': days,
      'reminder': reminder,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'WorkoutPlan(id: $id, title: $title, notes: $notes, exercises: ${exercises?.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Exercise model
class Exercise {
  final String muscle;
  final String exercise;
  final int sets;
  final int reps;
  final WeightRange weightRange;

  Exercise({
    required this.muscle,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weightRange,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      muscle: json['muscle'],
      exercise: json['exercise'],
      sets: json['sets'],
      reps: json['reps'],
      weightRange: WeightRange.fromJson(json['weightRange']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'muscle': muscle,
      'exercise': exercise,
      'sets': sets,
      'reps': reps,
      'weightRange': weightRange.toJson(),
    };
  }
}

class WeightRange {
  final int min;
  final int max;

  WeightRange({
    required this.min,
    required this.max,
  });

  factory WeightRange.fromJson(Map<String, dynamic> json) {
    return WeightRange(
      min: json['min'],
      max: json['max'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}