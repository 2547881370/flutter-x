import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';

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

  Widget _mySliverAppBar() {
    return SliverAppBar(
      pinned: false,
      floating: true,
      // title: Text('返回',
      //     style:
      //         TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(35))),
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
                flex: 2,
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
                        style: TextStyle(fontWeight: FontWeight.bold))),
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

  Widget _mySliverComment() {
    return SliverToBoxAdapter(child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          _mySliverAppBar(),
          _mySliverTitle(),
          _mySliverContent(),
          _mySliverComment()
        ],
      ),
    ));
  }
}
