// To parse this JSON data, do
//
//     final authLoginModel = authLoginModelFromJson(jsonString);

import 'dart:convert';

AuthLoginModel authLoginModelFromJson(String str) =>
    AuthLoginModel.fromJson(json.decode(str));

String authLoginModelToJson(AuthLoginModel data) => json.encode(data.toJson());

class AuthLoginModel {
  AuthLoginModel({
    this.data,
    this.code,
    this.message,
  });

  Data data;
  int code;
  String message;

  factory AuthLoginModel.fromJson(Map<String, dynamic> json) => AuthLoginModel(
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
    this.token,
    this.userId,
    this.username,
    this.password,
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
  });

  String token;
  int userId;
  String username;
  String password;
  String nick;
  String avatar;
  int gender;
  int age;
  int role;
  int experience;
  int credits;
  String identityTitle;
  String identityColor;
  int level;
  String levelColor;
  int integral;
  int uuid;
  String integralNick;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        userId: json["userID"],
        username: json["username"],
        password: json["password"],
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
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userID": userId,
        "username": username,
        "password": password,
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
      };
}
