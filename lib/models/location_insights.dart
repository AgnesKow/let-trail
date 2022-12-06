// To parse this JSON data, do
//
//     final locationInsights = locationInsightsFromJson(jsonString);

import 'dart:convert';
import 'dart:ui';

LocationInsights locationInsightsFromJson(String str) =>
    LocationInsights.fromJson(json.decode(str));

String locationInsightsToJson(LocationInsights data) =>
    json.encode(data.toJson());

class LocationInsights {
  LocationInsights({
    required this.title,
    required this.image,
    required this.color,
  });

  String title;
  String image;
  Color color;

  factory LocationInsights.fromJson(Map<String, dynamic> json) =>
      LocationInsights(
        title: json["title"],
        image: json["image"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
        "color": color,
      };
}
