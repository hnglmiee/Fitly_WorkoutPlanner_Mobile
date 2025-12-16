import 'package:flutter/material.dart';

class SchedulePlan {
  final DateTime date; // ✅ THÊM FIELD NÀY
  final String dayLabel;
  final String title;
  final String description;
  final String tag;
  final Color backgroundColor;
  final bool outlined;

  const SchedulePlan({
    required this.date, // ✅ LƯU date
    required this.dayLabel,
    required this.title,
    required this.description,
    required this.tag,
    required this.backgroundColor,
    this.outlined = false,
  });
}
