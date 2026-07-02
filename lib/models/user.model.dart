class UserModel {
  final int id;
  final String full_name;
  final String email;
  final String username;

  UserModel({
    required this.id,
    required this.full_name,
    required this.email,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      full_name: json['full_name'],
      email: json['email'],
      username: json['username'],
    );
  }
}
