import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/widget/list/no_image_item.dart';
import 'package:tutu/core/widget/list/one_image_item.dart';
import 'package:tutu/core/widget/list/three_image_item.dart';
import 'package:tutu/models/posts_list_model.dart';
import 'package:tutu/page/home/tab_home.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  FocusNode blankNode = FocusNode();
  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  TextEditingController _searchController = TextEditingController();

  PostsQueryForm queryForm;
  PostsListModel searchData;

  //滑动控制器
  ScrollController _controller;

  Future _getPostsList() async {
    final response = await XHttp.postJson(NWApi.postslist, {
      "limit": 10,
      "page": queryForm.page,
      "tag_id": 0,
      "sort_by": "",
      "title": _searchController.text
    });
    PostsListModel res = PostsListModel.fromJson(response);
    if (res.code == 200) {
      if (searchData != null && queryForm.page != 1) {
        var _data = searchData;
        _data.data.addAll(res.data);
        res = _data;
      }
      setState(() {
        searchData = res;
      });
    }
    return true;
  }

  Widget _searchSliverAppBar() {
    return AppBar(
        elevation: 0.0, //去掉阴影效果
        // pinned: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: ScreenUtil()
                    .setHeight(MediaQuery.of(context).padding.top / 3),
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  height: ScreenUtil().setHeight(70),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: ScreenUtil().setWidth(20),
                  ),
                  Container(
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: TextFormField(
                              scrollPadding: EdgeInsets.all(0.0),
                              autofocus: false,
                              controller: _searchController,
                              decoration: InputDecoration(
                                // labelText: I18n.of(context).loginName,
                                hintText: '请输入标题',
                                hintStyle: TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                              //校验用户名
                              validator: (v) {}))),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(120),
              height: ScreenUtil().setHeight(10),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                highlightColor: Colors.blue[700],
                colorBrightness: Brightness.dark,
                splashColor: Colors.grey,
                child: Text("搜索",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  searchData = null;
                  queryForm.page = 1;
                  await _getPostsList();
                  _controller.jumpTo(0);
                  return true;
                },
              ))
        ]);
  }

  Widget _searchSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          var info = searchData.data[index];

          int imgLength = info.images.length;
          if (imgLength >= 3) {
            info.images = info.images.sublist(0, 3);
            return ThreeImageItem(
                postId: info.postId,
                images: info.images.map((b) => b.url).toList(),
                title: info.title,
                userName: info.user.username,
                detail: info.detail,
                commentCount: info.commentCount,
                hit: info.hit);
          } else if (imgLength >= 1) {
            return OneImageItem(
              postId: info.postId,
              images: info.images.map((b) => b.url).toList(),
              title: info.title,
              userName: info.user.username,
              detail: info.detail,
              commentCount: info.commentCount,
              hit: info.hit,
            );
          } else {
            return NoImageItem(
              postId: info.postId,
              images: info.images.map((b) => b.url).toList(),
              title: info.title,
              userName: info.user.username,
              detail: info.detail,
              commentCount: info.commentCount,
              hit: info.hit,
            );
          }
          ;
        },
        childCount: searchData == null ? -1 : searchData.data.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //初始化控制器
    _controller = ScrollController();

    _controller.addListener(() {
      closeKeyboard(context);
    });

    queryForm = PostsQueryForm(
      page: 1,
    );
  }

  @override
  void dispose() {
    //销毁控制器
    _controller.dispose();
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
                child: Column(
                  children: <Widget>[
                    _searchSliverAppBar(),
                    Expanded(
                      flex: 1,
                      child: Container(
                          child: EasyRefresh(
                        footer: MaterialFooter(),
                        onLoad: () async {
                          closeKeyboard(context);
                          queryForm.page = queryForm.page + 1;
                          return await _getPostsList();
                        },
                        child: CustomScrollView(
                            controller: _controller,
                            physics: BouncingScrollPhysics(),
                            slivers: <Widget>[
                              _searchSliverList(),
                            ]),
                      )),
                    ),
                  ],
                ))));
  }
}
