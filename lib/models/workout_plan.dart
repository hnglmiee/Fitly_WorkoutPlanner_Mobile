class WorkoutPlan {
  final int id;
  final String title;
  final String notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WorkoutPlan({
    required this.id,
    required this.title,
    required this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) {
    return WorkoutPlan(
      id: json['id'],
      title: json['title'],
      notes: json['notes'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  @override
  String toString() {
    return 'WorkoutPlan(id: $id, title: $title, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WorkoutPlan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
