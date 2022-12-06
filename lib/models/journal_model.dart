import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

JournalModel journalModelFromJson(String str) =>
    JournalModel.fromJson(json.decode(str));

String journalModelToJson(JournalModel data) => json.encode(data.toJson());

class JournalModel {
  JournalModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.createdAt,
    required this.lastActivityAt,
    required this.publisherId,
  });

  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final Timestamp createdAt;
  final Timestamp lastActivityAt;
  final String publisherId;

  factory JournalModel.fromJson(Map<String, dynamic> json) => JournalModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        createdAt: json["created_at"],
        lastActivityAt: json["last_activity_at"],
        publisherId: json["publisher_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "thumbnail": thumbnail,
        "created_at": createdAt,
        "last_activity_at": lastActivityAt,
        "publisher_id": publisherId,
      };
}
