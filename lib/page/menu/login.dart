import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/privacy.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/loading_dialog.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/models/auth_%E2%80%8Blogin_model.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';
import 'package:flutter_template/utils/provider.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  bool _isUnameErrorText = false;
  bool _isPwdErrorText = false;

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
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  topContainerColor(),
                  topPositioned(child: buildForm(context))
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(100),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: TextFormField(
                autofocus: false,
                controller: _unameController,
                decoration: InputDecoration(
                  // labelText: I18n.of(context).loginName,
                  hintText: I18n.of(context).loginNameHint,
                  hintStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                //校验用户名
                validator: (v) {
                  if (v.trim().length > 0) {
                    setState(() {
                      _isUnameErrorText = false;
                    });
                  } else {
                    setState(() {
                      _isUnameErrorText = true;
                    });
                  }
                }),
          ),
          _isUnameErrorText
              ? Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(I18n.of(context).loginNameError,
                      style: TextStyle(
                          color: Colors.red, fontSize: ScreenUtil().setSp(25))),
                )
              : Container(),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Container(
              height: ScreenUtil().setHeight(100),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                      hintText: I18n.of(context).passwordHint,
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
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
                    if (v.trim().length >= 6) {
                      setState(() {
                        _isPwdErrorText = false;
                      });
                    } else {
                      setState(() {
                        _isPwdErrorText = true;
                      });
                    }
                  })),
          _isPwdErrorText
              ? Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(I18n.of(context).passwordError,
                      style: TextStyle(
                          color: Colors.red, fontSize: ScreenUtil().setSp(25))),
                )
              : Container(),

          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 20),
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

    XHttp.postJson("/auth/login", {
      "username": _unameController.text,
      "password": _pwdController.text
    }).then((response) {
      Navigator.pop(context);
      AuthLoginModel data = AuthLoginModel.fromJson(response);
      if (data.code == 200) {
        userProfile.nickName = data.data.nick;
        ToastUtils.toast(I18n.of(context).loginSuccess);
        XRouter.replace(Routes.mainHomePage);
      } else {
        ToastUtils.error(data.message);
      }
    }).catchError((onError) {
      Navigator.of(context).pop();
      ToastUtils.error(onError.response.data["message"]);
    });
  }
}

class topPositioned extends StatelessWidget {
  final Widget child;
  const topPositioned({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: ScreenUtil().setHeight(260),
      child: Container(
        width: ScreenUtil().setWidth(750),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setHeight(20),
            horizontal: ScreenUtil().setWidth(50)),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.black,
          width: 0.0,
          style: BorderStyle.none,
        )),
        child: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setHeight(100),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: ScreenUtil().setHeight(5),
                              color: Theme.of(context).primaryColor))),
                  child: Text(
                    I18n.of(context).signIn,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: ScreenUtil().setSp(40),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              child
            ],
          ),
          padding: EdgeInsets.symmetric(
              vertical: ScreenUtil().setHeight(50),
              horizontal: ScreenUtil().setWidth(40)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black, blurRadius: 15, spreadRadius: 0.1)
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
        ),
      ),
    );
  }
}

class topContainerColor extends StatelessWidget {
  const topContainerColor({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: ScreenUtil().setHeight(400),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    );
  }
}
