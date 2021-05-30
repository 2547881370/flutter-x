import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tutu/core/http/baseApi.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/core/widget/loading_dialog.dart';
import 'package:tutu/generated/i18n.dart';
import 'package:tutu/router/route_map.gr.dart';
import 'package:tutu/router/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutu/utils/provider.dart';
import 'package:dio/dio.dart' as _dio;
import 'package:tutu/utils/sputils.dart';

class UserConfigPage extends StatefulWidget {
  @override
  _UserConfigPageState createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  final picker = ImagePicker();
  File _image;

  Future getImageBuff() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null || pickedFile.path == null) return false;

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
      ///创建Dio
      _dio.Dio dio = new _dio.Dio();

      String path = pickedFile.path;

      Map<String, dynamic> map = Map();
      map["file"] = await _dio.MultipartFile.fromFile(path);
      map["userID"] = SPUtils.getUserInfo().data.userId;

      ///通过FormData
      _dio.FormData formData = _dio.FormData.fromMap(map);
      print(formData);

      dio.options.headers['token'] = SPUtils.getUserInfo().data.token;

      _dio.Response response = await dio.post(
        NWApi.baseApi + NWApi.fileUploadFile,
        data: formData,
        onSendProgress: (int progress, int total) {
          print("当前进度是 $progress 总进度是  $total");
        },
      );
      ToastUtils.toast("上传成功");
      UserProfile userProfile =
          Provider.of<UserProfile>(context, listen: false);
      await userProfile.refreshUserInfo();
    } catch (err) {
      ToastUtils.toast("上传失败");
    } finally {
      Navigator.of(context).pop();
    }
  }

  Widget _userConfigAppBar() {
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
        "账号设置",
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            _userConfigAppBar(),
            ListTile(
              onTap: () {
                getImageBuff();
              },
              title: Text('更换头像'),
              trailing: Icon(Icons.chevron_right),
            ),
            ListTile(
              onTap: () {
                XRouter.push('${Routes.userConfigUsernamePage}');
              },
              title: Text('更换昵称'),
              trailing: Icon(Icons.chevron_right),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  highlightColor: Colors.blue[700],
                  colorBrightness: Brightness.dark,
                  splashColor: Colors.grey,
                  child: Text("退出登录",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    UserProfile userProfile =
                        Provider.of<UserProfile>(context, listen: false);
                    userProfile.nickName = "";
                    userProfile.userInfo = null;
                    XRouter.replace(Routes.loginPage);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
