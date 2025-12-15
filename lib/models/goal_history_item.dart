import 'package:flutter/material.dart';

enum GoalStatus { completed, canceled }

class GoalHistoryItem {
  final String title;
  final String type;
  final GoalStatus status;
  final String imageUrl;

  GoalHistoryItem({
    required this.title,
    required this.type,
    required this.status,
    required this.imageUrl,
  });

  /// 🔹 Màu nền theo trạng thái
  Color get backgroundColor {
    switch (status) {
      case GoalStatus.completed:
        return const Color(0xFFE9FBF0); // xanh nhạt
      case GoalStatus.canceled:
        return const Color(0xFFFFEEEE); // đỏ nhạt
    }
  }

  /// 🔹 Text trạng thái
  String get statusText {
    switch (status) {
      case GoalStatus.completed:
        return "Completed";
      case GoalStatus.canceled:
        return "Canceled";
    }
  }

  /// 🔹 Màu chữ trạng thái
  Color get statusColor {
    switch (status) {
      case GoalStatus.completed:
        return Colors.green;
      case GoalStatus.canceled:
        return Colors.red;
    }
  }
}
