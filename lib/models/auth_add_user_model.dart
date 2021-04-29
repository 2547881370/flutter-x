// To parse this JSON data, do
//
//     final authAddUserModel = authAddUserModelFromJson(jsonString);

import 'dart:convert';

AuthAddUserModel authAddUserModelFromJson(String str) =>
    AuthAddUserModel.fromJson(json.decode(str));

String authAddUserModelToJson(AuthAddUserModel data) =>
    json.encode(data.toJson());

class AuthAddUserModel {
  AuthAddUserModel({
    this.data,
    this.code,
    this.message,
  });

  Data data;
  int code;
  String message;

  factory AuthAddUserModel.fromJson(Map<String, dynamic> json) =>
      AuthAddUserModel(
        data: Data.fromJson(json["data"]),
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "code": code,
        "message": message,
      };
}

class Data {
  Data({
    this.password,
    this.username,
    this.nick,
    this.avatar,
    this.gender,
    this.age,
    this.role,
    this.experience,
    this.credits,
    this.identityTitle,
    this.identityColor,
    this.level,
    this.levelColor,
    this.integral,
    this.uuid,
    this.integralNick,
    this.userId,
  });

  String password;
  String username;
  dynamic nick;
  dynamic avatar;
  dynamic gender;
  dynamic age;
  dynamic role;
  dynamic experience;
  dynamic credits;
  dynamic identityTitle;
  dynamic identityColor;
  dynamic level;
  dynamic levelColor;
  dynamic integral;
  dynamic uuid;
  dynamic integralNick;
  int userId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        password: json["password"],
        username: json["username"],
        nick: json["nick"],
        avatar: json["avatar"],
        gender: json["gender"],
        age: json["age"],
        role: json["role"],
        experience: json["experience"],
        credits: json["credits"],
        identityTitle: json["identityTitle"],
        identityColor: json["identityColor"],
        level: json["level"],
        levelColor: json["levelColor"],
        integral: json["integral"],
        uuid: json["uuid"],
        integralNick: json["integralNick"],
        userId: json["userID"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
        "username": username,
        "nick": nick,
        "avatar": avatar,
        "gender": gender,
        "age": age,
        "role": role,
        "experience": experience,
        "credits": credits,
        "identityTitle": identityTitle,
        "identityColor": identityColor,
        "level": level,
        "levelColor": levelColor,
        "integral": integral,
        "uuid": uuid,
        "integralNick": integralNick,
        "userID": userId,
      };
}
