import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserConfigUsernamePage extends StatefulWidget {
  @override
  _UserConfigUsernamePageState createState() => _UserConfigUsernamePageState();
}

class _UserConfigUsernamePageState extends State<UserConfigUsernamePage> {
  TextEditingController _fromTextEditingController = TextEditingController();
  FocusNode blankNode = FocusNode();

  Widget _userConfigUserNameAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0, //去掉阴影效果
      leading: IconButton(
        color: Colors.black,
        icon: Icon(Icons.navigate_before),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "更改昵称",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            alignment: Alignment.center,
            child: Text("完成"),
          ),
        ),
      ],
    );
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          closeKeyboard(context);
        },
        child: Column(
          children: <Widget>[
            _userConfigUserNameAppBar(),
            Container(
              height: ScreenUtil().setHeight(100),
              child: TextFormField(
                  autofocus: false,
                  controller: _fromTextEditingController,
                  decoration: InputDecoration(
                    // labelText: I18n.of(context).loginName,
                    hintText: '请输入昵称',
                    hintStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  //校验用户名
                  validator: (v) {}),
            ),
            Expanded(
              flex: 1,
              child: Container(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
