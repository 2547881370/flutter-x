import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatelessWidget {
  final Function callback;
  ErrorPage({this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          Text(
            "页面加载失败",
            style: TextStyle(
              color: Colors.grey,
              fontSize: ScreenUtil().setSp(30),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          MaterialButton(
            height: 30,
            elevation: 5,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            padding: EdgeInsets.all(8),
            child: Text(
              "刷新重试",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              if (callback != null) {
                callback();
              }
            },
          ),
        ],
      ),
    );
  }
}
