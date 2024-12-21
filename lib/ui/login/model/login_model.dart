// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.success,
    required this.token,
  });

  bool success;
  Token token;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        success: json["success"],
        token: Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "token": token.toJson(),
      };
}

class Token {
  Token({
    required this.headers,
    required this.original,
    required this.exception,
  });

  Headers headers;
  Original original;
  dynamic exception;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        headers: Headers.fromJson(json["headers"]),
        original: Original.fromJson(json["original"]),
        exception: json["exception"],
      );

  Map<String, dynamic> toJson() => {
        "headers": headers.toJson(),
        "original": original.toJson(),
        "exception": exception,
      };
}

class Headers {
  Headers();

  factory Headers.fromJson(Map<String, dynamic> json) => Headers();

  Map<String, dynamic> toJson() => {};
}

class Original {
  Original({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  String accessToken;
  String tokenType;
  int expiresIn;
  User user;

  factory Original.fromJson(Map<String, dynamic> json) => Original(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.deviceToken,
    this.emailVerifiedAt,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  int id;
  String name;
  String email;
  String phone;
  dynamic deviceToken;
  dynamic emailVerifiedAt;
  int active;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        deviceToken: json["device_token"],
        emailVerifiedAt: json["email_verified_at"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "device_token": deviceToken,
        "email_verified_at": emailVerifiedAt,
        "active": active,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
