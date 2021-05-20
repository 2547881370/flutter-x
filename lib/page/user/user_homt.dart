import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutu/core/utils/xuifont.dart';
import 'package:tutu/router/route_map.gr.dart';
import 'package:tutu/router/router.dart';
import 'package:tutu/utils/sputils.dart';

class UserEnumItem {
  Icon icon;
  String enumName;
  Function callback;
  UserEnumItem({this.icon, this.enumName, this.callback});
}

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<UserEnumItem> enumList = [
    UserEnumItem(
      icon: Icon(XUIIcons.my_history, color: Colors.green),
      enumName: '浏览记录',
      callback: () {},
    ),
    UserEnumItem(
      icon: Icon(XUIIcons.shoucang_ash, color: Colors.red),
      enumName: '我的喜欢',
      callback: () {},
    ),
    UserEnumItem(
      icon: Icon(XUIIcons.dianzan_ash, color: Colors.deepPurpleAccent),
      enumName: '我的点赞',
      callback: () {},
    ),
    UserEnumItem(
      icon: Icon(XUIIcons.my_contacts, color: Colors.yellow),
      enumName: "联系我们",
      callback: () {},
    ),
  ];

  Widget _userSliverAppBar() {
    return SliverAppBar(
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          child: Text("个人中心"),
        ));
  }

  Widget _userSliverInfo() {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.grey[600],
        height: ScreenUtil().setHeight(330),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
            vertical: ScreenUtil().setHeight(80)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
                onTap: () {
                  XRouter.push('${Routes.userConfigPage}');
                },
                child: Container(
                  width: ScreenUtil().setWidth(140),
                  child: ClipOval(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                            ),
                        imageUrl: SPUtils.getUserInfo().data.avatar),
                  ),
                )),
            SizedBox(
              width: ScreenUtil().setWidth(40),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      SPUtils.getUserInfo().data.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(35),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Text("用户ID：${SPUtils.getUserInfo().data.userId}",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _userSliverText() {
    return SliverToBoxAdapter(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey[300],
            ),
          ),
        ),
        child: Text(
          "我的账户",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(30),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _userSliverEnum() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(50)),
        child: Row(
            children: enumList.map((b) {
          return Expanded(
            flex: 1,
            child: InkWell(
                onTap: b.callback,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      b.icon,
                      SizedBox(
                        height: ScreenUtil().setHeight(20),
                      ),
                      Text(b.enumName),
                    ],
                  ),
                )),
          );
        }).toList()),
      ),
    );
  }

  Widget _userSliverTitle() {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          onTap: () {},
          title: Text('意见建议'),
          trailing: Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: () {},
          title: Text('用户交流群'),
          trailing: Icon(Icons.chevron_right),
        ),
      ]),
      // delegate: _mySliverChildListDelegate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              _userSliverAppBar(),
              _userSliverInfo(),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ScreenUtil().setHeight(30),
                ),
              ),
              _userSliverText(),
              _userSliverEnum(),
              _userSliverTitle(),
            ]),
      ),
    );
  }
}
