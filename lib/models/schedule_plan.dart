import 'package:flutter/material.dart';

class SchedulePlan {
  final int id;
  final DateTime date;
  final String title;
  final String? description; // ✅ Nullable
  final String? tag; // ✅ Nullable
  final Color? backgroundColor; // ✅ Nullable
  final String dayLabel;
  final bool outlined;

  const SchedulePlan({
    required this.id,
    required this.date,
    required this.title,
    this.description, // ✅ Optional
    this.tag, // ✅ Optional
    this.backgroundColor, // ✅ Optional
    this.dayLabel = '', // ✅ Default value
    this.outlined = false,
  });
}
