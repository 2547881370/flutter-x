import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/xuifont.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'PhotoGalleryPage.dart';

class ImageDetailed extends StatefulWidget {
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

  Widget _mySliverAppBar() {
    return SliverAppBar(
      pinned: false,
      floating: true,
      leading: IconButton(
        color: Colors.white,
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      expandedHeight: kToolbarHeight,
      flexibleSpace: Container(color: Theme.of(context).primaryColor),
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
            minHeight: 200.0,
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
                    alignment: Alignment.centerLeft, child: Text("标题"))),
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
                            Text('1000', style: TextStyle(color: Colors.black))
                          ]))),
                      Expanded(
                          child: Container(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                            Icon(Icons.remove_red_eye, color: Colors.black),
                            SizedBox(width: 10),
                            Text('1000', style: TextStyle(color: Colors.black))
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
                border:
                    Border(bottom: BorderSide(width: 1, color: Colors.grey))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                                  'http://photocdn.sohu.com/tvmobilemvms/20150907/144160323071011277.jpg')),
                                    )),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text("昵称",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text("个性签名",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))
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
                      "文字内容文字内容文字内容文字内容文字内容文字内容文字内容"
                      "文字内容文字内容文字内容文字内容文字内容文字内容文字内容"
                      "文字内容文字内容文字内容文字内容文字内容文字内容文字内容"
                      "文字内容文字内容文字内容文字内容文字内容文字内容文字内容",
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
                                    photoList: detailsImageData,
                                    index: index)));
                      },
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: detailsImageData[index]['url'],
                      ),
                    );
                  },
                  itemCount: detailsImageData.length,
                )
              ],
            )));
  }

  Widget _mySliverCommentCount() {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Text("评论 : 10"),
    ));
  }

  Widget _mySliverComment() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _mySliverCommentItem();
        },
        childCount: 20,
      ),
    );
  }

  Widget _mySliverCommentItem() {
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
                      height: ScreenUtil().setHeight(100),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: ClipOval(
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                    ),
                                imageUrl:
                                    'http://photocdn.sohu.com/tvmobilemvms/20150907/144160323071011277.jpg')),
                      )),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("昵称",
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论"
                                    "评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论评论",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
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
                  child: Container(
                    child: Container(
                      height: ScreenUtil().setHeight(80),
                      alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: TextFormField(
                          autofocus: false,
                          controller: _commentController,
                          decoration: InputDecoration(
                            // labelText: I18n.of(context).loginName,
                            hintText: '一起来吐槽',
                            hintStyle: TextStyle(fontSize: 12),
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                          ),
                          //校验用户名
                          validator: (v) {}),
                    ),
                  )),
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
                          setState(() {
                            collectionState = !collectionState;
                          });
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
                          setState(() {
                            likeState = !likeState;
                          });
                          return !likeState;
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

  @override
  void initState() {
    controller.setNetworkDataSource(
        'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4',
        autoPlay: true);
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
                _mySliverPersistentHeaderVideo(),
                _mySliverTitle(),
                _mySliverContent(),
                _mySliverCommentCount(),
                _mySliverComment(),
                SliverToBoxAdapter(
                  child: Container(
                    height: ScreenUtil().setHeight(100),
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
