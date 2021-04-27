import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  SPUtils._internal();

  static SharedPreferences _spf;

  static Future<SharedPreferences> init() async {
    if (_spf == null) {
      _spf = await SharedPreferences.getInstance();
    }
    return _spf;
  }

  ///主题
  static Future<bool> saveThemeIndex(int value) {
    return _spf.setInt('key_theme_color', value);
  }

  static int getThemeIndex() {
    if (_spf.containsKey('key_theme_color')) {
      return _spf.getInt('key_theme_color');
    }
    return 0;
  }

  ///语言
  static Future<bool> saveLocale(String locale) {
    return _spf.setString('key_locale', locale);
  }

  static String getLocale() {
    return _spf.getString('key_locale');
  }

  ///昵称
  static Future<bool> saveNickName(String nickName) {
    return _spf.setString('key_nickname', nickName);
  }

  static String getNickName() {
    return _spf.getString('key_nickname');
  }

  ///是否同意隐私协议
  static Future<bool> saveIsAgreePrivacy(bool isAgree) {
    return _spf.setBool('key_agree_privacy', isAgree);
  }

  static bool isAgreePrivacy() {
    if (!_spf.containsKey('key_agree_privacy')) {
      return false;
    }
    return _spf.getBool('key_agree_privacy');
  }

  ///是否已登陆
  static bool isLogined() {
    String nickName = getNickName();
    return nickName != null && nickName.isNotEmpty;
  }

  /// 设置沉浸式状态栏
  /// 状态栏样式 沉浸式状态栏
  static statusBar() {
      // 白色沉浸式状态栏颜色  白色文字
      SystemUiOverlayStyle light = SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarDividerColor: null,
        /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );

      // 黑色沉浸式状态栏颜色 黑色文字
      SystemUiOverlayStyle dark = SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF000000),
        systemNavigationBarDividerColor: null,
        /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
        statusBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );
      // 这个地方你可以去掉三目运算符 直接调用你想要的 效果即可
      SystemChrome.setSystemUIOverlayStyle(light);
  }
}
