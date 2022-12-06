import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.username,
    required this.emailAddress,
    required this.imageUrl,
  });

  String id;
  String username;
  String emailAddress;
  String imageUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        emailAddress: json["email_address"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email_address": emailAddress,
        "image_url": imageUrl,
      };
}
