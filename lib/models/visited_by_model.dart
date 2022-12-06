import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

VisitedByModel visitedByModelFromJson(String str) =>
    VisitedByModel.fromJson(json.decode(str));

String visitedByModelToJson(VisitedByModel data) => json.encode(data.toJson());

class VisitedByModel {
  VisitedByModel({
    required this.id,
    required this.userId,
    required this.heritageTrailId,
    required this.themeId,
    required this.placeId,
    required this.placeImage,
    required this.placeTagLine,
    required this.placeDescription,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String heritageTrailId;
  final String themeId;
  final String placeId;
  final String placeImage;
  final String placeTagLine;
  final String placeDescription;
  final Timestamp createdAt;

  factory VisitedByModel.fromJson(Map<String, dynamic> json) => VisitedByModel(
        id: json["id"],
        userId: json["user_id"],
        heritageTrailId: json["heritage_trail_id"],
        themeId: json["theme_id"],
        placeId: json["place_id"],
        placeImage: json["place_image"],
        placeTagLine: json["place_tagline"],
        placeDescription: json["place_description"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "heritage_trail_id": heritageTrailId,
        "theme_id": themeId,
        "place_image": placeImage,
        "place_id": placeId,
        "place_tagline": placeTagLine,
        "place_description": placeDescription,
        "created_at": createdAt,
      };
}
