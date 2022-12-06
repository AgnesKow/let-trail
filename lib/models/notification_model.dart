import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

NotificationModel notificationModalFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModalToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.userId,
    required this.locationId,
    required this.isPlace,
    required this.message,
    required this.title,
    required this.createdOn,
  });

  String id;
  String userId;
  String locationId;
  bool isPlace;
  String message;
  String title;
  Timestamp createdOn;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        userId: json["user_id"],
        locationId: json["location_id"],
        isPlace: json["is_place"],
        message: json["message"],
        title: json["title"],
        createdOn: json["created_on"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "location_id": locationId,
        "is_place": isPlace,
        "message": message,
        "title": title,
        "created_on": createdOn,
      };
}
