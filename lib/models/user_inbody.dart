// lib/models/user_inbody.dart

class UserInbody {
  final int id;
  final int age;
  final DateTime measuredAt;
  final double? height;
  final double? weight;
  final double? bodyFatPercentage;
  final double? muscleMass;
  final String? notes;
  final DateTime? createdAt;

  UserInbody({
    required this.id,
    required this.age,
    required this.measuredAt,
    this.height,
    this.weight,
    this.bodyFatPercentage,
    this.muscleMass,
    this.notes,
    this.createdAt,
  });

  factory UserInbody.fromJson(Map<String, dynamic> json) {
    return UserInbody(
      id: json['id'] as int,
      age: json['age'] as int,
      measuredAt: DateTime.parse(json['measuredAt'] as String),
      height: json['height'] != null
          ? (json['height'] as num).toDouble()
          : null,
      weight: json['weight'] != null
          ? (json['weight'] as num).toDouble()
          : null,
      bodyFatPercentage: json['bodyFatPercentage'] != null
          ? (json['bodyFatPercentage'] as num).toDouble()
          : null,
      muscleMass: json['muscleMass'] != null
          ? (json['muscleMass'] as num).toDouble()
          : null,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // ✅ ADDED: toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'measuredAt': measuredAt.toIso8601String(),
      'height': height,
      'weight': weight,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'notes': notes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}