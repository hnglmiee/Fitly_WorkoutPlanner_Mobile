class GoalProgress {
  final String status;
  final Goal goal;
  final int progress; // 0–100

  GoalProgress({
    required this.status,
    required this.goal,
    required this.progress,
  });

  factory GoalProgress.fromJson(Map<String, dynamic> json) {
    return GoalProgress(
      status: json['status'] ?? '',
      goal: Goal.fromJson(json['goal'] ?? {}),
      progress: _calculateProgress(json),
    );
  }
}

class Goal {
  final String goalName;
  final String notes;

  Goal({required this.goalName, required this.notes});

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(goalName: json['goalName'] ?? '', notes: json['notes'] ?? '');
  }
}

int _calculateProgress(Map<String, dynamic> result) {
  final goal = result['goal'];
  final inbody = result['lastestInBody'];

  if (goal == null || inbody == null) return 0;

  final targetWeight = goal['targetWeight'];
  final currentWeight = inbody['weight'];

  if (targetWeight == null || currentWeight == null) return 0;

  final diff = (currentWeight - targetWeight).abs();
  final percent = (100 - diff * 10).clamp(0, 100);

  return percent.toInt();
}
