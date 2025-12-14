class UserInbody {
  final double? weight;
  final double? height;
  final DateTime? createdAt;

  UserInbody({this.weight, this.height, this.createdAt});

  factory UserInbody.fromJson(Map<String, dynamic> json) {
    return UserInbody(
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
