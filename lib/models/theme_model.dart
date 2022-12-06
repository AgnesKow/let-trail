import 'dart:convert';

ThemeModel themeModelFromJson(String str) =>
    ThemeModel.fromJson(json.decode(str));

String themeModelToJson(ThemeModel data) => json.encode(data.toJson());

class ThemeModel {
  ThemeModel({
    required this.id,
    required this.title,
    required this.trailId,
    required this.travelInformation,
    required this.website,
  });

  final String id;
  final String title;
  final String trailId;
  final String travelInformation;
  final String website;

  factory ThemeModel.fromJson(Map<String, dynamic> json) => ThemeModel(
        id: json["id"],
        title: json["title"],
        trailId: json["trail_id"],
        travelInformation: json["travel_information"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "trail_id": trailId,
        "travel_information": travelInformation,
        "website": website,
      };
}
