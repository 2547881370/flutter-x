import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/core/widget/loading_dialog.dart';
import 'package:tutu/generated/i18n.dart';
import 'package:tutu/models/auth_add_user_model.dart';

import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 响应空白处的焦点的Node
  bool _isShowPassWord = false;
  bool _isShowPassWordRepeat = false;
  FocusNode blankNode = FocusNode();
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdRepeatController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();
  bool _isUnameErrorText = false;
  bool _isPwdErrorText = false;
  bool _isPwdRepeatErrorText = false;
  String _passwordRepeaErrorTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // 去除阴影
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          )),
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
              topContainerColor(height: 252),
              topInkWell(),
              topPositioned(
                top: 10,
                child: buildForm(context),
                title: I18n.of(context).register,
              )
            ],
          ),
        ),
      ),
    );
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
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: I18n.of(context).loginNameHint,
                  hintStyle: TextStyle(fontSize: 12),
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
                          color: Theme.of(context).primaryColor,
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
                }),
          ),
          _isPwdErrorText
              ? Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(I18n.of(context).passwordError,
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
                controller: _pwdRepeatController,
                decoration: InputDecoration(
                    hintText: I18n.of(context).passwordHint,
                    hintStyle: TextStyle(fontSize: 12),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isShowPassWordRepeat
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: showPassWordRepeat)),
                obscureText: !_isShowPassWordRepeat,
                //校验密码
                validator: (v) {
                  if (v.trim().length >= 6) {
                    if (_pwdController.text == _pwdRepeatController.text) {
                      setState(() {
                        _isPwdRepeatErrorText = false;
                      });
                    } else {
                      // 密码不一致
                      _passwordRepeaErrorTitle =
                          I18n.of(context).passwordRepeaError;
                      setState(() {
                        _isPwdRepeatErrorText = true;
                      });
                    }
                  } else {
                    // 密码少于个数
                    _passwordRepeaErrorTitle = I18n.of(context).passwordError;
                    setState(() {
                      _isPwdRepeatErrorText = true;
                    });
                  }
                }),
          ),

          _isPwdRepeatErrorText
              ? Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(_passwordRepeaErrorTitle,
                      style: TextStyle(
                          color: Colors.red, fontSize: ScreenUtil().setSp(25))),
                )
              : Container(),

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
                    child: Text(I18n.of(context).register,
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                      Form.of(context).validate();
                      if (isFormValue()) {
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

  /// 表单数据是否为空
  bool isFormValue() {
    return !_isUnameErrorText && !_isPwdErrorText && !_isPwdRepeatErrorText;
  }

  ///点击控制密码是否显示
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  ///点击控制密码是否显示
  void showPassWordRepeat() {
    setState(() {
      _isShowPassWordRepeat = !_isShowPassWordRepeat;
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

    XHttp.postJson(NWApi.addUser, {
      "username": _unameController.text,
      "password": _pwdController.text
    }).then((response) {
      Navigator.pop(context);
      AuthAddUserModel data = AuthAddUserModel.fromJson(response);
      if (data.code == 200) {
        ToastUtils.toast(I18n.of(context).registerSuccess);
        Navigator.of(context).pop();
      } else {
        ToastUtils.error(data.message);
      }
    }).catchError((onError) {
      Navigator.of(context).pop();
      ToastUtils.error(onError.response.data["message"]);
    });
  }
}
