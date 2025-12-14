class UserInfo {
  final int id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? roleName;
  final String? gender;
  final DateTime? birthday;
  final double? weight;
  final double? height;

  UserInfo({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.roleName,
    this.gender,
    this.birthday,
    this.weight,
    this.height,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      roleName: json['roleName'],
      gender: json['gender'],
      birthday:
          json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
    );
  }
}
