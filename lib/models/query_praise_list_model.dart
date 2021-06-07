// To parse this JSON data, do
//
//     final queryPraiseListModel = queryPraiseListModelFromJson(jsonString);

import 'dart:convert';

QueryPraiseListModel queryPraiseListModelFromJson(String str) => QueryPraiseListModel.fromJson(json.decode(str));

String queryPraiseListModelToJson(QueryPraiseListModel data) => json.encode(data.toJson());

class QueryPraiseListModel {
  QueryPraiseListModel({
    this.data,
    this.code,
    this.message,
  });

  List<Datum> data;
  int code;
  String message;

  factory QueryPraiseListModel.fromJson(Map<String, dynamic> json) => QueryPraiseListModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    code: json["code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "code": code,
    "message": message,
  };
}

class Datum {
  Datum({
    this.praiseId,
    this.createTime,
    this.posts,
  });

  int praiseId;
  String createTime;
  Posts posts;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    praiseId: json["praiseId"],
    createTime: json["createTime"],
    posts: Posts.fromJson(json["posts"]),
  );

  Map<String, dynamic> toJson() => {
    "praiseId": praiseId,
    "createTime": createTime,
    "posts": posts.toJson(),
  };
}

class Posts {
  Posts({
    this.postId,
    this.title,
    this.detail,
    this.voice,
    this.recommendationLevel,
    this.score,
    this.scoreTxt,
    this.hit,
    this.commentCount,
    this.notice,
    this.weight,
    this.isGood,
    this.createTime,
    this.activeTime,
    this.line,
    this.tagid,
    this.status,
    this.praise,
    this.isAuthention,
    this.isRich,
    this.appOrientation,
    this.isAppPost,
    this.appSize,
    this.isGif,
    this.images,
    this.user,
  });

  int postId;
  String title;
  String detail;
  dynamic voice;
  int recommendationLevel;
  int score;
  String scoreTxt;
  int hit;
  int commentCount;
  int notice;
  int weight;
  int isGood;
  String createTime;
  String activeTime;
  int line;
  int tagid;
  int status;
  int praise;
  int isAuthention;
  int isRich;
  int appOrientation;
  int isAppPost;
  int appSize;
  int isGif;
  List<Image> images;
  User user;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
    postId: json["postID"],
    title: json["title"],
    detail: json["detail"],
    voice: json["voice"],
    recommendationLevel: json["recommendationLevel"],
    score: json["score"],
    scoreTxt: json["scoreTxt"],
    hit: json["hit"],
    commentCount: json["commentCount"],
    notice: json["notice"],
    weight: json["weight"],
    isGood: json["isGood"],
    createTime: json["createTime"],
    activeTime: json["activeTime"],
    line: json["line"],
    tagid: json["tagid"],
    status: json["status"],
    praise: json["praise"],
    isAuthention: json["isAuthention"],
    isRich: json["isRich"],
    appOrientation: json["appOrientation"],
    isAppPost: json["isAppPost"],
    appSize: json["appSize"],
    isGif: json["isGif"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "postID": postId,
    "title": title,
    "detail": detail,
    "voice": voice,
    "recommendationLevel": recommendationLevel,
    "score": score,
    "scoreTxt": scoreTxt,
    "hit": hit,
    "commentCount": commentCount,
    "notice": notice,
    "weight": weight,
    "isGood": isGood,
    "createTime": createTime,
    "activeTime": activeTime,
    "line": line,
    "tagid": tagid,
    "status": status,
    "praise": praise,
    "isAuthention": isAuthention,
    "isRich": isRich,
    "appOrientation": appOrientation,
    "isAppPost": isAppPost,
    "appSize": appSize,
    "isGif": isGif,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "user": user.toJson(),
  };
}

class Image {
  Image({
    this.imgId,
    this.url,
  });

  int imgId;
  String url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imgId: json["imgId"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "imgId": imgId,
    "url": url,
  };
}

class User {
  User({
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

  factory User.fromJson(Map<String, dynamic> json) => User(
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
    integralNick: json["integralNick"] == null ? null : json["integralNick"],
  );

  Map<String, dynamic> toJson() => {
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
    "integralNick": integralNick == null ? null : integralNick,
  };
}
