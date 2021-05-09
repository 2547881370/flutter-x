import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/core/utils/utils.dart';
import 'package:flutter_template/core/widget/list/three_image_item.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';

// 三张图片以下
class OneImageItem extends StatelessWidget implements ImageItemInfo {
  // 文章id
  final int postId;

  // 文章标题
  final String title;

  // 文章简介
  final String detail;

  // 文章图片列表
  final List<String> images;

  // 发布人名称
  final String userName;

  // 留言次数
  final int commentCount;

  // 查看次数
  final int hit;

  const OneImageItem(
      {Key key,
      this.postId,
      this.title,
      this.detail,
      this.images,
      this.userName,
      this.commentCount,
      this.hit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          XRouter.push(Routes.imageDetailed);
        },
        child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),
            width: ScreenUtil().setWidth(750),
            child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(children: <Widget>[
                      Container(
                          height: ScreenUtil().setHeight(250),
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          alignment: Alignment.centerLeft,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                    ),
                                imageUrl: Utils.rtrim(images[0])),
                          )),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10),
                                    Text(
                                      detail,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          child: Text(userName,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(24),
                                                  color: Colors.black)),
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 1, vertical: 1),
                                                child: Row(children: <Widget>[
                                                  Expanded(
                                                      child: Container(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <
                                                                  Widget>[
                                                        Icon(
                                                            Icons
                                                                .message_outlined,
                                                            color: Colors.grey),
                                                        SizedBox(width: 10),
                                                        Text(
                                                            commentCount
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ]))),
                                                  Expanded(
                                                      child: Container(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: <
                                                                  Widget>[
                                                        Icon(
                                                            Icons
                                                                .remove_red_eye,
                                                            color: Colors.grey),
                                                        SizedBox(width: 10),
                                                        Text(hit.toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))
                                                      ])))
                                                ])))
                                      ],
                                    )
                                  ])))
                    ])))));
  }
}
