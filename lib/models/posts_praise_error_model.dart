// To parse this JSON data, do
//
//     final postsPraiseErrorModel = postsPraiseErrorModelFromJson(jsonString);

import 'dart:convert';

PostsPraiseErrorModel postsPraiseErrorModelFromJson(String str) =>
    PostsPraiseErrorModel.fromJson(json.decode(str));

String postsPraiseErrorModelToJson(PostsPraiseErrorModel data) =>
    json.encode(data.toJson());

class PostsPraiseErrorModel {
  PostsPraiseErrorModel({
    this.code,
    this.timestamp,
    this.path,
    this.message,
  });

  int code;
  DateTime timestamp;
  String path;
  String message;

  factory PostsPraiseErrorModel.fromJson(Map<String, dynamic> json) =>
      PostsPraiseErrorModel(
        code: json["code"],
        timestamp: DateTime.parse(json["timestamp"]),
        path: json["path"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "timestamp": timestamp.toIso8601String(),
        "path": path,
        "message": message,
      };
}
