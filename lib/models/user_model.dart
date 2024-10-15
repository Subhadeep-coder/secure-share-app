class UserModel {
  String id;
  String name;
  String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> user) {
    return UserModel(
      id: user['id'] ?? '',
      name: user['name'] ?? '',
      email: user['email'] ?? '',
    );
  }
}
