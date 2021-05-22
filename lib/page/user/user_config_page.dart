import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutu/router/route_map.gr.dart';
import 'package:tutu/router/router.dart';
import 'package:image_picker/image_picker.dart';

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
                  onPressed: () async {},
                ))
          ],
        ),
      ),
    );
  }
}
