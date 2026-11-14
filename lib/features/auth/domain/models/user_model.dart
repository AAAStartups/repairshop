class UserModel {
  final String uid;
  final String phone;
  final String? name;
  final String? email;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.phone,
    this.name,
    this.email,
    required this.createdAt,
  });

  UserModel copyWith({
    String? name,
    String? email,
  }) {
    return UserModel(
      uid: uid,
      phone: phone,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt,
    );
  }
}
