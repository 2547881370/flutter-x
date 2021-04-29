// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  ErrorModel({
    this.code,
    this.timestamp,
    this.path,
    this.message,
  });

  int code;
  DateTime timestamp;
  String path;
  String message;

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
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
