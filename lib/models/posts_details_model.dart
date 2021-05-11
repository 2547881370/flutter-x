// To parse this JSON data, do
//
//     final postsDetailsModel = postsDetailsModelFromJson(jsonString);

import 'dart:convert';

PostsDetailsModel postsDetailsModelFromJson(String str) =>
    PostsDetailsModel.fromJson(json.decode(str));

String postsDetailsModelToJson(PostsDetailsModel data) =>
    json.encode(data.toJson());

class PostsDetailsModel {
  PostsDetailsModel({
    this.data,
    this.code,
    this.message,
  });

  Data data;
  int code;
  String message;

  factory PostsDetailsModel.fromJson(Map<String, dynamic> json) =>
      PostsDetailsModel(
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
    this.detailedId,
    this.posts,
    this.comments,
  });

  int detailedId;
  Posts posts;
  List<Comment> comments;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        detailedId: json["detailedId"],
        posts: Posts.fromJson(json["posts"]),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detailedId": detailedId,
        "posts": posts.toJson(),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class Comment {
  Comment({
    this.commentId,
    this.text,
    this.voice,
    this.voiceTime,
    this.score,
    this.scoreTxt,
    this.seq,
    this.createTime,
    this.state,
    this.scoreUserCount,
    this.scorecount,
    this.praise,
    this.images,
    this.user,
  });

  int commentId;
  String text;
  String voice;
  int voiceTime;
  int score;
  String scoreTxt;
  int seq;
  String createTime;
  int state;
  int scoreUserCount;
  int scorecount;
  int praise;
  List<dynamic> images;
  User user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentId: json["commentID"],
        text: json["text"],
        voice: json["voice"],
        voiceTime: json["voiceTime"],
        score: json["score"],
        scoreTxt: json["scoreTxt"],
        seq: json["seq"],
        createTime: json["createTime"],
        state: json["state"],
        scoreUserCount: json["scoreUserCount"],
        scorecount: json["scorecount"],
        praise: json["praise"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "commentID": commentId,
        "text": text,
        "voice": voice,
        "voiceTime": voiceTime,
        "score": score,
        "scoreTxt": scoreTxt,
        "seq": seq,
        "createTime": createTime,
        "state": state,
        "scoreUserCount": scoreUserCount,
        "scorecount": scorecount,
        "praise": praise,
        "images": List<dynamic>.from(images.map((x) => x)),
        "user": user.toJson(),
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
        integralNick:
            json["integralNick"] == null ? null : json["integralNick"],
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
    this.user,
    this.images,
  });

  int postId;
  String title;
  String detail;
  dynamic voice;
  dynamic recommendationLevel;
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
  User user;
  List<DetailsImage> images;

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
        user: User.fromJson(json["user"]),
        images: List<DetailsImage>.from(
            json["images"].map((x) => DetailsImage.fromJson(x))),
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
        "user": user.toJson(),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
      };
}

class DetailsImage {
  DetailsImage({
    this.imgId,
    this.url,
  });

  int imgId;
  String url;

  factory DetailsImage.fromJson(Map<String, dynamic> json) => DetailsImage(
        imgId: json["imgId"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "imgId": imgId,
        "url": url,
      };
}
