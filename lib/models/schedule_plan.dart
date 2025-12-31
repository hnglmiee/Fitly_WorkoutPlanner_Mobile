import 'package:flutter/material.dart';

class SchedulePlan {
  final int id;
  final DateTime date;
  final String title;
  final String? description;
  final String? tag;
  final Color? backgroundColor;
  final String dayLabel;
  final bool outlined;

  const SchedulePlan({
    required this.id,
    required this.date,
    required this.title,
    this.description,
    this.tag,
    this.backgroundColor,
    this.dayLabel = '',
    this.outlined = false,
  });
}
