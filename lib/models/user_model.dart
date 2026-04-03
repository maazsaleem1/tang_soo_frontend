class UserModel {
  UserModel({
    required this.id,
    required this.status,
    required this.email,
    required this.isVerified,
    this.isCreated = true,
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
    this.subscriptionStatus = '',
    this.planId,
  });

  final int? id;
  final String status;
  final String email;
  final bool isVerified;
  /// From API `isCreated`. When `false`, the user should complete onboarding profile.
  final bool isCreated;
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
  final String subscriptionStatus;
  final int? planId;

  String get fullName => '$firstName $lastName'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      status: (json['status'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      isVerified: json['isVerified'] == true,
      isCreated:
          json['isCreated'] == null ? true : json['isCreated'] == true,
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
      subscriptionStatus: (json['subscriptionStatus'] ?? '').toString(),
      planId: json['planId'] is int
          ? json['planId'] as int
          : int.tryParse('${json['planId'] ?? ''}'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'email': email,
      'isVerified': isVerified,
      'isCreated': isCreated,
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
      'subscriptionStatus': subscriptionStatus,
      'planId': planId,
    };
  }
}
