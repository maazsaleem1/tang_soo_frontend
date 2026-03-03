class UserModel {
  UserModel({
    required this.id,
    required this.status,
    required this.email,
    required this.isVerified,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.country,
    required this.mobile,
    required this.address,
    required this.postalCode,
    required this.profileImageUrl,
    required this.guardianName,
    required this.guardianActive,
    required this.preferences,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.token,
  });

  final int? id;
  final String status;
  final String email;
  final bool isVerified;
  final String firstName;
  final String lastName;
  final String? dob;
  final String country;
  final String mobile;
  final String address;
  final String postalCode;
  final String profileImageUrl;
  final String guardianName;
  final bool guardianActive;
  final Map<String, dynamic> preferences;
  final String role;
  final String createdAt;
  final String updatedAt;
  final String token;

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      status: (json['status'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      isVerified: json['isVerified'] == true,
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      dob: json['dob']?.toString(),
      country: (json['country'] ?? '').toString(),
      mobile: (json['mobile'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      postalCode: (json['postalCode'] ?? '').toString(),
      profileImageUrl: (json['profileImageUrl'] ?? '').toString(),
      guardianName: (json['guardianName'] ?? '').toString(),
      guardianActive: json['guardianActive'] == true,
      preferences: (json['preferences'] as Map?)?.cast<String, dynamic>() ?? {},
      role: (json['role'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? '').toString(),
      updatedAt: (json['updatedAt'] ?? '').toString(),
      token: (json['token'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'email': email,
      'isVerified': isVerified,
      'firstName': firstName,
      'lastName': lastName,
      'dob': dob,
      'country': country,
      'mobile': mobile,
      'address': address,
      'postalCode': postalCode,
      'profileImageUrl': profileImageUrl,
      'guardianName': guardianName,
      'guardianActive': guardianActive,
      'preferences': preferences,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'token': token,
    };
  }
}
