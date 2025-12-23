import 'package:flutter/material.dart';

class ExerciseForm {
  String? muscle;
  String? exercise;
  int sets;
  int reps;
  RangeValues weightRange;

  ExerciseForm({
    this.muscle,
    this.exercise,
    this.sets = 1,
    this.reps = 1,
    RangeValues? weightRange,
  }) : weightRange = weightRange ?? const RangeValues(0, 40);
}
