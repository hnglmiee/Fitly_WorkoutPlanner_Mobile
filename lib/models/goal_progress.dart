// lib/models/goal_progress.dart

import 'package:workout_tracker_mini_project_mobile/models/user_inbody.dart';
import '../models/goal.dart';

class GoalProgress {
  final int? id; // ✅ Nullable vì API có thể trả về null
  final String status;
  final int workoutSessionThisWeek;
  final UserInbody? lastestInBody;
  final Goal goal;

  GoalProgress({
    this.id,
    required this.status,
    required this.workoutSessionThisWeek,
    this.lastestInBody,
    required this.goal,
  });

  // ✅ Computed properties cho UI
  int get completedWorkouts => workoutSessionThisWeek;

  int get totalWorkouts {
    if (goal.targetWorkoutSessionsPerWeek == null) return 0;
    final weeks = goal.endDate.difference(goal.startDate).inDays / 7;
    return (goal.targetWorkoutSessionsPerWeek! * weeks).ceil();
  }

  double get progressPercentage {
    if (totalWorkouts == 0) return 0;
    return (completedWorkouts / totalWorkouts * 100).clamp(0, 100);
  }

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      id: json['id'] as int?, // ✅ CRITICAL FIX: Thêm ? để accept null
      status: json['status'] as String? ?? 'UNKNOWN', // ✅ Safe với default
      workoutSessionThisWeek: json['workoutSessionThisWeek'] as int? ?? 0, // ✅ Safe với default
      lastestInBody: json['lastestInBody'] != null
          ? UserInbody.fromJson(json['lastestInBody'] as Map<String, dynamic>)
          : null,
      goal: Goal.fromJson(json['goal'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'workoutSessionThisWeek': workoutSessionThisWeek,
      'lastestInBody': lastestInBody?.toJson(),
      'goal': goal.toJson(),
    };
  }
}