class UserInbody {
  final double? weight;
  final double? height;
  final DateTime? createdAt;
  final int id;
  final int age;
  final DateTime measuredAt;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final String? notes;

  UserInbody({
    required this.id,
    required this.age,
    required this.measuredAt,
    required this.height,
    required this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.notes, this.createdAt});

  factory UserInbody.fromJson(Map<String, dynamic> json) {
    return UserInbody(
      id: json['id'] as int,
      age: json['age'] as int,
      measuredAt: DateTime.parse(json['measuredAt'] as String),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bodyFatPercentage: json['bodyFatPercentage'] != null
          ? (json['bodyFatPercentage'] as num).toDouble()
          : null,
      muscleMass: json['muscleMass'] != null
          ? (json['muscleMass'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
    );
  }
}