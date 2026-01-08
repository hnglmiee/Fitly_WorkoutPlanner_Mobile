import 'package:workout_tracker_mini_project_mobile/models/user_inbody.dart';
import '../models/goal.dart';

class GoalProgress {
  final String status;
  final int workoutSessionThisWeek;
  final UserInbody? lastestInBody;
  final Goal goal;

  GoalProgress({
    required this.status,
    required this.workoutSessionThisWeek,
    this.lastestInBody,
    required this.goal,
  });

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      status: json['status'] as String,
      workoutSessionThisWeek: json['workoutSessionThisWeek'] as int,
      lastestInBody: json['lastestInBody'] != null
          ? UserInbody.fromJson(json['lastestInBody'] as Map<String, dynamic>)
          : null,
      goal: Goal.fromJson(json['goal'] as Map<String, dynamic>),
    );
  }
}