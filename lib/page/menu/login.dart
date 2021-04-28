import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/privacy.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/loading_dialog.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 响应空白处的焦点的Node
  bool _isShowPassWord = false;
  FocusNode blankNode = FocusNode();
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (!SPUtils.isAgreePrivacy()) {
      PrivacyUtils.showPrivacyDialog(context, onAgressCallback: () {
        Navigator.of(context).pop();
        SPUtils.saveIsAgreePrivacy(true);
        ToastUtils.success(I18n.of(context).agreePrivacy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: GestureDetector(
            onTap: () {
              // 点击空白页面关闭键盘
              closeKeyboard(context);
            },
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async {
          return Future.value(false);
        });
  }

  //构建表单
  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: <Widget>[
          TextFormField(
              autofocus: false,
              controller: _unameController,
              decoration: InputDecoration(
                  labelText: I18n.of(context).loginName,
                  hintText: I18n.of(context).loginNameHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.person)),
              //校验用户名
              validator: (v) {
                return v.trim().length > 0
                    ? null
                    : I18n.of(context).loginNameError;
              }),
          TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: I18n.of(context).password,
                  hintText: I18n.of(context).passwordHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isShowPassWord
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord)),
              obscureText: !_isShowPassWord,
              //校验密码
              validator: (v) {
                return v.trim().length >= 6
                    ? null
                    : I18n.of(context).passwordError;
              }),
          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Builder(builder: (context) {
                  return ElevatedButton(
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        padding: EdgeInsets.all(15.0)),
                    child: Text(I18n.of(context).login,
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                      if (Form.of(context).validate()) {
                        onSubmit(context);
                      }
                    },
                  );
                })),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///点击控制密码是否显示
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }

  //验证通过提交数据
  void onSubmit(BuildContext context) {
    closeKeyboard(context);

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

    /// context.watch<T>()， 一方法使得widget能够监听泛型T上发生的改变。
    /// context.read<T>()，直接返回T，不会监听改变。
    /// context.select<T， R>(R cb(T value))，允许widget只监听T上的一部分(R)。
    /// 或者使用 Provider.of<T>(context) 这一静态方法，它的表现类似 watch ，而在你为 listen 参数传入 false 时(如 Provider.of<T>(context，listen: false) ), 它的表现类似于 read。
    /// 值得注意的是，context.read<T>() 方法不会在值变化时使得widget重新构建， 并且不能在 StatelessWidget.build/State.build 内调用. 换句话说， 它可以在除了这两个方法以外的任意之处调用。
    /// 即当前返回的是一个read,不会监听值的变化,一般这种用于直接获取参数,不用于更新widget的用途
    UserProfile userProfile = Provider.of<UserProfile>(context, listen: false);

    XHttp.post("/user/login", {
      "username": _unameController.text,
      "password": _pwdController.text
    }).then((response) {
      Navigator.pop(context);
      if (response['errorCode'] == 0) {
        userProfile.nickName = response['data']['nickname'];
        ToastUtils.toast(I18n.of(context).loginSuccess);
        XRouter.replace(Routes.mainHomePage);
      } else {
        ToastUtils.error(response['errorMsg']);
      }
    }).catchError((onError) {
      Navigator.of(context).pop();
      ToastUtils.error(onError);
    });
  }
}
