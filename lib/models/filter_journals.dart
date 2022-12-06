// To parse this JSON data, do
//
//     final filterJournals = filterJournalsFromJson(jsonString);
import 'dart:convert';

FilterJournals filterJournalsFromJson(String str) =>
    FilterJournals.fromJson(json.decode(str));

String filterJournalsToJson(FilterJournals data) => json.encode(data.toJson());

class FilterJournals {
  FilterJournals({
    required this.key,
    required this.value,
  });

  final String key;
  final String value;

  factory FilterJournals.fromJson(Map<String, dynamic> json) => FilterJournals(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
