class WorkoutPlan {
  final int id;
  final String title;
  final String notes;

  WorkoutPlan({required this.id, required this.title, required this.notes});

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      title: json['title'],
      notes: json['notes'],
    );
  }
}
