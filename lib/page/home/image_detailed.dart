import 'dart:convert';
import 'dart:math';

import 'package:auto_route/auto_route_annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/core/http/baseApi.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/http/request/request.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/utils/xuifont.dart';
import 'package:flutter_template/core/widget/loading_dialog.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/models/posts_details_model.dart';
import 'package:flutter_template/models/posts_praise_error_model.dart';
import 'package:flutter_template/models/posts_praise_model.dart';
import 'package:flutter_template/models/query_user_praise_one_model.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'photo_gallery_page.dart';

class ImageDetailed extends StatefulWidget {
  final String postId;

  const ImageDetailed({Key key, @QueryParam('postId') this.postId})
      : super(key: key);
  @override
  _ImageDetailedState createState() => _ImageDetailedState();
}

class _ImageDetailedState extends State<ImageDetailed> {
  List<Map> detailsImageData = [
    {
      'url':
          "http://photocdn.sohu.com/tvmobilemvms/20150907/144160323071011277.jpg",
      'imgId': 1
    },
    {
      'url':
          "http://photocdn.sohu.com/tvmobilemvms/20150907/144158380433341332.jpg",
      'imgId': 2
    },
    {
      'url':
          "http://photocdn.sohu.com/tvmobilemvms/20150907/144160286644953923.jpg",
      'imgId': 3
    },
    {
      'url':
          "http://photocdn.sohu.com/tvmobilemvms/20150902/144115156939164801.jpg",
      'imgId': 4
    },
    {
      'url':
          "http://photocdn.sohu.com/tvmobilemvms/20150907/144159406950245847.jpg",
      'imgId': 5
    },
  ];

  FocusNode blankNode = FocusNode();
  TextEditingController _commentController = TextEditingController();
  // 收藏
  bool collectionState = false;
  // 点赞
  bool likeState = false;
  IjkMediaController controller = IjkMediaController();

  PostsDetailsModel res = PostsDetailsModel.fromJson({
    "data": {
      "detailedId": 1344,
      "posts": {
        "postID": 47863583,
        "title": "【网图】百合花开",
        "detail": "这淡淡的花香味",
        "voice": null,
        "recommendationLevel": null,
        "score": 0,
        "scoreTxt": "",
        "hit": 608,
        "commentCount": 2,
        "notice": 0,
        "weight": 0,
        "isGood": 0,
        "createTime": "1620563913957",
        "activeTime": "1620123837000",
        "line": 0,
        "tagid": 5602,
        "status": 0,
        "praise": 1,
        "isAuthention": 0,
        "isRich": 0,
        "appOrientation": 0,
        "isAppPost": 0,
        "appSize": 0,
        "isGif": 0,
        "user": {
          "userID": 16693142,
          "username": "SH",
          "password": "123456",
          "nick": "殇孤",
          "avatar":
              "http://cdn.u1.huluxia.com/g3/M02/51/FE/wKgBOVq_YUiAZ-7vAADdwgZhlmY5486.ht",
          "gender": 1,
          "age": 20,
          "role": 0,
          "experience": 67685,
          "credits": 1403,
          "identityTitle": "",
          "identityColor": "0",
          "level": 7,
          "levelColor": "4278190335",
          "integral": 0,
          "uuid": 0,
          "integralNick": "初入门槛"
        },
        "images": [
          {
            "imgId": 11083,
            "url":
                "http://cdn.u1.huluxia.com/g4/M03/5C/DC/rBAAdmB_D1yAVxpSAAD3zHOJf3s230.jpg"
          },
          {
            "imgId": 11084,
            "url":
                "http://cdn.u1.huluxia.com/g4/M03/5C/DC/rBAAdmB_D1yAJ0WOAADrbMdcQ4A522.jpg"
          },
          {
            "imgId": 11085,
            "url":
                "http://cdn.u1.huluxia.com/g4/M03/5C/DC/rBAAdmB_D12AVqwnAAEY25i7CwE797.jpg"
          },
          {
            "imgId": 11086,
            "url":
                "http://cdn.u1.huluxia.com/g4/M03/5C/DC/rBAAdmB_D16AQckpAAKQcuYNzJQ563.jpg"
          },
          {
            "imgId": 11087,
            "url":
                "http://cdn.u1.huluxia.com/g4/M03/5C/DC/rBAAdmB_D1-AItT6AAD_Ysg8jvU007.jpg"
          }
        ]
      },
      "comments": [
        {
          "commentID": 639541866,
          "text": "喜欢这种风格的话 说一声  指不定还能再找出来点呢",
          "voice": "",
          "voiceTime": 0,
          "score": 0,
          "scoreTxt": "",
          "seq": 1,
          "createTime": "1618999154000",
          "state": 1,
          "scoreUserCount": 0,
          "scorecount": 0,
          "praise": 0,
          "images": [],
          "user": {
            "userID": 16693142,
            "username": "SH",
            "password": "123456",
            "nick": "殇孤",
            "avatar":
                "http://cdn.u1.huluxia.com/g3/M02/51/FE/wKgBOVq_YUiAZ-7vAADdwgZhlmY5486.ht",
            "gender": 1,
            "age": 20,
            "role": 0,
            "experience": 67685,
            "credits": 1403,
            "identityTitle": "",
            "identityColor": "0",
            "level": 7,
            "levelColor": "4278190335",
            "integral": 0,
            "uuid": 0,
            "integralNick": "初入门槛"
          }
        },
        {
          "commentID": 640317154,
          "text": "gkd[滑稽][滑稽][滑稽]",
          "voice": "",
          "voiceTime": 0,
          "score": 0,
          "scoreTxt": "",
          "seq": 2,
          "createTime": "1620123837000",
          "state": 1,
          "scoreUserCount": 0,
          "scorecount": 0,
          "praise": 0,
          "images": [],
          "user": {
            "userID": 25042026,
            "username": "SH",
            "password": "123456",
            "nick": "莫得感情的鸽子",
            "avatar":
                "http://cdn.u1.huluxia.com/g4/M03/40/6D/rBAAdmBqbx2ANQcQAADhalkRS7M475.jpg",
            "gender": 2,
            "age": 0,
            "role": 0,
            "experience": 2320,
            "credits": 1,
            "identityTitle": "",
            "identityColor": "0",
            "level": 3,
            "levelColor": "4278255411",
            "integral": 0,
            "uuid": 0,
            "integralNick": null
          }
        }
      ]
    },
    "code": 200,
    "message": "请求成功"
  });

  Widget _mySliverAppBar() {
    return SliverAppBar(
      leading: IconButton(
        color: Colors.white,
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        background: CachedNetworkImage(
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                ),
            imageUrl:
                res.data?.posts.images[res.data?.posts.images.length - 1].url),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _mySliverPersistentHeaderVideo() {
    return SliverPersistentHeader(
        //是否固定头布局 默认false
        pinned: true,
        //是否浮动 默认false
        floating: false,
        //必传参数,头布局内容
        delegate: MySliverDelegate(
            //缩小后的布局高度
            minHeight: 100.0,
            //展开后的高度
            maxHeight: 200.0,
            child: Container(
              width: ScreenUtil().setWidth(750),
              height: 200.0,
              child: IjkPlayer(
                mediaController: controller,
              ),
            )));
  }

  Widget _mySliverTitle() {
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
          child: Row(children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(res.data?.posts.title))),
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                            Icon(Icons.message_outlined, color: Colors.black),
                            SizedBox(width: 10),
                            Text(res.data?.posts.commentCount.toString(),
                                style: TextStyle(color: Colors.black))
                          ]))),
                      Expanded(
                          child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                            Icon(Icons.remove_red_eye, color: Colors.black),
                            SizedBox(width: 10),
                            Text(res.data?.posts.hit.toString(),
                                style: TextStyle(color: Colors.black))
                          ])))
                    ])))
          ])),
    );
  }

  Widget _mySliverContent() {
    return SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey[200]))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Container(
                                height: ScreenUtil().setHeight(100),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipOval(
                                      child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                color: Colors.grey[200],
                                              ),
                                          imageUrl:
                                              res.data?.posts.user.avatar)),
                                )),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(res.data?.posts.user.username,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                          Text(res.data?.posts.user.nick,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold))
                                        ])))
                          ]))),
                  Container(
                      alignment: Alignment.topRight,
                      width: ScreenUtil().setWidth(100),
                      child: Text("楼主",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)))
                ]),
                SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(10)),
                    child: Text(
                      res.data?.posts.detail,
                    )),
                GridView.builder(
                  shrinkWrap: true, //解决 listview 嵌套报错
                  physics: NeverScrollableScrollPhysics(), //禁用滑动事件
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 2,
                      //纵轴间距
                      mainAxisSpacing: 10.0,
                      //横轴间距
                      crossAxisSpacing: 10.0,
                      //子组件宽高长度比例
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhotpGalleryPage(
                                    photoList: res.data.posts.images,
                                    index: index)));
                      },
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: res.data?.posts.images[index].url,
                      ),
                    );
                  },
                  itemCount: res.data?.posts.images.length,
                )
              ],
            )));
  }

  Widget _mySliverCommentCount() {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.grey[200]))),
      child: Text("评论 : ${res.data?.comments.length}"),
    ));
  }

  Widget _mySliverComment() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _mySliverCommentItem(res.data?.comments[index]);
        },
        childCount: res.data?.comments.length,
      ),
    );
  }

  Widget _mySliverCommentItem(Comment comments) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Expanded(
            flex: 1,
            child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Container(
                      height: ScreenUtil().setHeight(60),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipOval(
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                    ),
                                imageUrl: comments.user.avatar)),
                      )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                Text(comments.user.username,
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: ScreenUtil().setHeight(10),
                                ),
                                Text(comments.text,
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(30),
                                      color: Colors.black,
                                    )),
                              ])))
                ]))),
      ]),
    );
  }

  Widget _myPositionedCommentInput() {
    return Positioned(
        bottom: 0,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(width: 1, color: Colors.grey))),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: ScreenUtil().setWidth(750),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Row(children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Stack(children: <Widget>[
                            Positioned(
                                top: ScreenUtil()
                                    .setHeight((100 / 2) - (80 / 2)),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    height: ScreenUtil().setHeight(80),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))))),
                            Container(
                              height: ScreenUtil().setHeight(100),
                              alignment: Alignment.bottomLeft,
                              child: TextFormField(
                                  autofocus: false,
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    // labelText: I18n.of(context).loginName,
                                    hintText: '说说你的看法',
                                    hintStyle: TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  //校验用户名
                                  validator: (v) {}),
                            )
                          ]),
                        )),
                    SizedBox(
                      width: ScreenUtil().setWidth(10),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                            child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          highlightColor: Colors.blue[700],
                          colorBrightness: Brightness.dark,
                          splashColor: Colors.grey,
                          child: Text("评论"),
                          onPressed: () async {
                            if (_commentController.text == '') {
                              ToastUtils.error("内容不能为空");
                              return false;
                            }
                            print(_commentController.text);
                            bool flag = await _createPostsComment(
                                ArticleComment(text: _commentController.text));
                            if (flag) {
                              _init();
                            }
                            _commentController.text = '';
                            closeKeyboard(context);
                          },
                        ))),
                  ])),
              SizedBox(
                width: ScreenUtil().setWidth(80),
              ),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      LikeButton(
                        onTap: (bool isLiked) async {
                          bool _isFlag = await _postsCollection(
                              ArticleOraiseRequset(postId: widget.postId),
                              status: collectionState
                                  ? ArticleStatus.cancel
                                  : ArticleStatus.determine);
                          if (_isFlag) {
                            setState(() {
                              collectionState = !collectionState;
                            });
                            return collectionState;
                          }
                          return collectionState;
                        },
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            XUIIcons.shoucang_ash,
                            color: collectionState ? Colors.red : Colors.grey,
                          );
                        },
                      ),
                      LikeButton(
                        onTap: (bool isLiked) async {
                          bool _isFlag = await _postsPraise(
                              ArticleOraiseRequset(postId: widget.postId),
                              status: likeState
                                  ? ArticleStatus.cancel
                                  : ArticleStatus.determine);
                          if (_isFlag) {
                            setState(() {
                              likeState = !likeState;
                            });
                            return likeState;
                          }
                          return likeState;
                        },
                        likeBuilder: (bool isLiked) {
                          return Icon(
                            XUIIcons.dianzan_ash,
                            color: likeState
                                ? Colors.deepPurpleAccent
                                : Colors.grey,
                          );
                        },
                      ),
                      // IconButton(
                      //     icon: Icon(XUIIcons.dianzan_ash), onPressed: () {}),
                    ],
                  )),
            ],
          ),
        ));
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  // 获取文章详情
  Future _initArticleInfo(postId) async {
    final response = await XHttp.postJson(NWApi.postsDetails, {
      "limit": 1000,
      "page": 1,
      "postId": postId,
    });
    PostsDetailsModel _res = PostsDetailsModel.fromJson(response);
    setState(() {
      res = _res;
    });

    if (_res.data.posts.voice != null) {
      Map<String, dynamic> voiceData =
          JsonDecoder().convert(_res.data.posts.voice);
      print(voiceData);
      String url = voiceData['videohost'] + voiceData['videofid'];
      controller.setNetworkDataSource(url, autoPlay: true);
    }
  }

  // 点赞
  Future _postsPraise(ArticleOraiseRequset query, {int status}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: Colors.black38,
            loadingView: SpinKitCircle(color: Colors.white),
          );
        });
    query.status = status;
    try {
      final response = await XHttp.postJson(NWApi.praise, {
        "status": query.status,
        "postId": query.postId,
        "userId": SPUtils.getUserInfo().data.userId
      });
      ToastUtils.success(response["message"]);
      return true;
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
      return false;
    } finally {
      Navigator.pop(context);
    }
  }

  // 获取用户是否点赞
  Future _istUserPostsPraise(IsArticleOraiseRequset query) async {
    try {
      final response = await XHttp.postJson(NWApi.queryUserPraiseOne, {
        "postId": query.postId,
        "userId": SPUtils.getUserInfo().data.userId
      });
      QueryUserPraiseOneModel _res = QueryUserPraiseOneModel.fromJson(response);
      print(_res);
      setState(() {
        likeState = true;
      });
      return true;
    } catch (err) {
      print(err);
      setState(() {
        likeState = false;
      });
      return false;
    }
  }

  // 收藏
  Future _postsCollection(ArticleOraiseRequset query, {int status}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: Colors.black38,
            loadingView: SpinKitCircle(color: Colors.white),
          );
        });

    query.status = status;
    try {
      final response = await XHttp.postJson(NWApi.collection, {
        "status": query.status,
        "postId": query.postId,
        "userId": SPUtils.getUserInfo().data.userId
      });
      ToastUtils.success(response["message"]);
      return true;
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
    } finally {
      Navigator.pop(context);
    }
  }

  // 获取用户是否收藏
  Future _istUserPostsCollection(IsArticleOraiseRequset query) async {
    try {
      final response = await XHttp.postJson(NWApi.queryUserCollectionOne, {
        "postId": query.postId,
        "userId": SPUtils.getUserInfo().data.userId
      });
      QueryUserPraiseOneModel _res = QueryUserPraiseOneModel.fromJson(response);
      print(_res);
      setState(() {
        collectionState = true;
      });
      return true;
    } catch (err) {
      print(err);
      setState(() {
        collectionState = false;
      });
      return false;
    }
  }

  // 用户评论
  Future _createPostsComment(ArticleComment query) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: Colors.black38,
            loadingView: SpinKitCircle(color: Colors.white),
          );
        });
    try {
      final response = await XHttp.postJson(NWApi.createPostsComment, {
        "postId": widget.postId,
        "userId": SPUtils.getUserInfo().data.userId,
        "text": query.text
      });
      ToastUtils.success(response["message"]);
      return true;
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
      return false;
    } finally {
      Navigator.pop(context);
    }
  }

  Future _init() async {
    await _istUserPostsPraise(IsArticleOraiseRequset(postId: widget.postId));

    await _istUserPostsCollection(
        IsArticleOraiseRequset(postId: widget.postId));

    await _initArticleInfo(widget.postId);
  }

  @override
  void initState() {
    print('postId =>>>>>>>>' + widget.postId);
    print('userId =>>>>>>>>' + SPUtils.getUserInfo().data.userId.toString());
    if (widget.postId != null) {
      _init();
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        // 点击空白页面关闭键盘
        closeKeyboard(context);
      },
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              // 去除滑动波纹
              physics: BouncingScrollPhysics(),
              slivers: [
                res.data.posts.voice != null
                    ? _mySliverPersistentHeaderVideo()
                    : _mySliverAppBar(),
                // _mySliverTitle(),
                _mySliverContent(),
                _mySliverCommentCount(),
                _mySliverComment(),
                SliverToBoxAdapter(
                  child: Container(
                    height: ScreenUtil().setHeight(130),
                  ),
                )
              ],
            ),
            _myPositionedCommentInput()
          ],
        ),
      ),
    ));
  }
}

class MySliverDelegate extends SliverPersistentHeaderDelegate {
  MySliverDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight; //最小高度
  final double maxHeight; //最大高度
  final Widget child; //子Widget布局

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override //是否需要重建
  bool shouldRebuild(MySliverDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
