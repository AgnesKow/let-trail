import 'dart:convert';

import 'package:flutter/material.dart';

PlacesAndColorsModel placesAndColorsModelFromJson(String str) =>
    PlacesAndColorsModel.fromJson(json.decode(str));

String placesAndColorsModelToJson(PlacesAndColorsModel data) =>
    json.encode(data.toJson());

class PlacesAndColorsModel {
  PlacesAndColorsModel({
    required this.markerColor,
    required this.polylineColor,
    required this.themeId,
  });

  final double markerColor;
  final Color polylineColor;
  final String themeId;

  factory PlacesAndColorsModel.fromJson(Map<String, dynamic> json) =>
      PlacesAndColorsModel(
        markerColor: json["marker_color"],
        polylineColor: json["polyline_color"],
        themeId: json["theme_id"],
      );

  Map<String, dynamic> toJson() => {
        "marker_color": markerColor,
        "polyline_color": polylineColor,
        "theme_id": themeId,
      };
}
