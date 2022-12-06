// To parse this JSON data, do
//
//     final emojiFlag = emojiFlagFromJson(jsonString);
import 'dart:convert';

EmojiFlag emojiFlagFromJson(String str) => EmojiFlag.fromJson(json.decode(str));

String emojiFlagToJson(EmojiFlag data) => json.encode(data.toJson());

class EmojiFlag {
  EmojiFlag({
    required this.value,
    required this.emoji,
  });

  final String value;
  final String emoji;

  factory EmojiFlag.fromJson(Map<String, dynamic> json) => EmojiFlag(
        value: json["value"],
        emoji: json["emoji"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "emoji": emoji,
      };
}
