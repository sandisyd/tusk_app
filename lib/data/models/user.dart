// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final int? id;
  final String? role;
  final String? name;
  final String? email;
  final String? password;
  final DateTime? cretedAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.role,
    this.name,
    this.email,
    this.password,
    this.cretedAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        role: json["role"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        cretedAt:
            json["cretedAt"] == null ? null : DateTime.parse(json["cretedAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "name": name,
        "email": email,
        "password": password,
        "cretedAt": cretedAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
