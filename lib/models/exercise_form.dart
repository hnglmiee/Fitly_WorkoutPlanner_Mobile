import 'package:flutter/material.dart';

class ExerciseForm {
  // ID fields từ API
  int? categoryId;
  int? exerciseId;

  // Name fields (để hiển thị và validation)
  String? muscle;
  String? exercise;

  int sets;
  int reps;
  RangeValues weightRange;

  ExerciseForm({
    this.categoryId,
    this.exerciseId,
    this.muscle,
    this.exercise,
    this.sets = 3,
    this.reps = 10,
    this.weightRange = const RangeValues(0, 50),
  });

  @override
  String toString() {
    return 'ExerciseForm(categoryId: $categoryId, exerciseId: $exerciseId, muscle: $muscle, exercise: $exercise, sets: $sets, reps: $reps)';
  }
}