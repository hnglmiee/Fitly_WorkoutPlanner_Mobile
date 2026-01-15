class WorkoutChartItem {
  final String label;
  final int sessions;

  WorkoutChartItem({
    required this.label,
    required this.sessions,
  });

  factory WorkoutChartItem.fromJson(Map<String, dynamic> json) {
    return WorkoutChartItem(
      // Handle both 'label' and 'lable' (API typo)
      label: json['label'] ?? json['lable'] ?? '',
      sessions: json['sessions'] ?? 0,
    );
  }
}