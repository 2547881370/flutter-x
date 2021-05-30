import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/core/widget/loading_dialog.dart';
import 'package:tutu/models/auth_%E2%80%8Blogin_model.dart';
import 'package:tutu/models/posts_praise_error_model.dart';
import 'package:tutu/utils/provider.dart';
import 'package:tutu/utils/sputils.dart';

class UserConfigUsernamePage extends StatefulWidget {
  @override
  _UserConfigUsernamePageState createState() => _UserConfigUsernamePageState();
}

class _UserConfigUsernamePageState extends State<UserConfigUsernamePage> {
  TextEditingController _fromTextEditingController = TextEditingController();
  FocusNode blankNode = FocusNode();

  Future _setUserNameApi() async {
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
      final response = await XHttp.postJson(NWApi.authUpdateUsername, {
        "username": _fromTextEditingController.text,
        "userID": SPUtils.getUserInfo().data.userId,
      });
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      AuthLoginModel res = AuthLoginModel.fromJson(response);
      await userProfile.refreshUserInfo();
      ToastUtils.success(res.message);
      Navigator.pop(context);
    } catch (err) {
      PostsPraiseErrorModel resError =
          PostsPraiseErrorModel.fromJson(err.response.data);
      ToastUtils.error(resError.message);
    } finally {
      Navigator.pop(context);
    }
  }

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
          onTap: () {
            if (_fromTextEditingController.text == null) {
              ToastUtils.waring("名称不能为空");
              return false;
            }
            _setUserNameApi();
          },
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
