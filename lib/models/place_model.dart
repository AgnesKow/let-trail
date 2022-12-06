import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PlaceModel placeModelFromJson(String str) =>
    PlaceModel.fromJson(json.decode(str));

String placeModelToJson(PlaceModel data) => json.encode(data.toJson());

class PlaceModel {
  PlaceModel({
    required this.id,
    required this.category,
    required this.description,
    required this.trailId,
    required this.imageUrl,
    required this.themeId,
    required this.address,
    required this.cultureStyle,
    required this.year,
    required this.website,
    required this.coordinate,
    required this.name,
  });

  final String id;
  final String category;
  final String description;
  final String trailId;
  final String imageUrl;
  final String themeId;
  final String address;
  final String cultureStyle;
  final int year;
  final String website;
  final GeoPoint coordinate;
  final String name;

  factory PlaceModel.fromJson(Map<String, dynamic> json) => PlaceModel(
        id: json["id"],
        category: json["category"],
        description: json["description"],
        trailId: json["trail_id"],
        imageUrl: json["image_url"],
        themeId: json["theme_id"],
        address: json["address"],
        cultureStyle: json["culture_style"],
        year: json["year"],
        website: json["website"],
        coordinate: json["coordinate"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "description": description,
        "trail_id": trailId,
        "image_url": imageUrl,
        "theme_id": themeId,
        "address": address,
        "culture_style": cultureStyle,
        "year": year,
        "website": website,
        "coordinate": coordinate,
        "name": name,
      };
}
