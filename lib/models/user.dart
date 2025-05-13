import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id; // ID của người dùng
  final String email; // Email của người dùng
  final String name; // Tên của người dùng
  final String password; // Mật khẩu của người dùng

  // Constructor
  User({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
  });

  // Phương thức từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0, // Fallback mặc định là 0
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
    );
  }

  // Phương thức chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id, // ID
      'email': email, // Email
      'name': name, // Tên
      'password': password, // Mật khẩu
    };
  }
}