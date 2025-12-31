// models/in_body_data.dart

class InBodyData {
  final int id;
  final String fullName;
  final DateTime measuredAt;
  final double height;
  final double weight;
  final double bodyFatPercentage;
  final double muscleMass;
  final double bmi;
  final double leanBodyMass;
  final String bodyFatTrend; // "stable", "up", "down"
  final String muscleMassTrend; // "stable", "up", "down"
  final String? notes;

  InBodyData({
    required this.id,
    required this.fullName,
    required this.measuredAt,
    required this.height,
    required this.weight,
    required this.bodyFatPercentage,
    required this.muscleMass,
    required this.bmi,
    required this.leanBodyMass,
    required this.bodyFatTrend,
    required this.muscleMassTrend,
    this.notes,
  });

  factory InBodyData.fromJson(Map<String, dynamic> json) {
    return InBodyData(
      id: json['id'],
      fullName: json['fullName'],
      measuredAt: DateTime.parse(json['measuredAt']),
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] as num).toDouble(),
      muscleMass: (json['muscleMass'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
      leanBodyMass: (json['leanBodyMass'] as num).toDouble(),
      bodyFatTrend: json['bodyFatTrend'],
      muscleMassTrend: json['muscleMassTrend'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'measuredAt': measuredAt.toIso8601String(),
      'height': height,
      'weight': weight,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'bmi': bmi,
      'leanBodyMass': leanBodyMass,
      'bodyFatTrend': bodyFatTrend,
      'muscleMassTrend': muscleMassTrend,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'InBodyData(id: $id, fullName: $fullName, measuredAt: $measuredAt)';
  }

  // ✅ Helper để tính total body water (estimate)
  double get estimatedTotalBodyWater {
    // Công thức ước tính: TBW = Lean Body Mass * 0.73
    return leanBodyMass * 0.73;
  }

  // ✅ Helper để format gender từ fullName hoặc notes
  String get gender {
    // TODO: Nếu backend có gender field, sử dụng từ API
    // Tạm thời return 'N/A' hoặc extract từ notes
    return 'N/A';
  }
}
