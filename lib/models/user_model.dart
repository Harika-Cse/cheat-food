class UserModel {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String role; // 'customer', 'admin', 'vendor'
  final String? profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    this.role = 'customer',
    this.profileImageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isAdmin => role == 'admin';

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? uid}) {
    return UserModel(
      uid: uid ?? map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'customer',
      profileImageUrl: map['profileImageUrl'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? role,
    String? profileImageUrl,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
    );
  }
}
