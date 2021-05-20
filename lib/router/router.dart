import 'package:auto_route/auto_route.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:tutu/core/widget/web_view_page.dart';

/**
 * 本项目使用了两个路由管理的库,一个是fluro和auto_route
 * fluro : 使用Handler定义路由,每个Handler返回对应的widget , 即 path =>> widget
 * auto_route : 相当于是一个中间件, 而我们整个框架都是使用auto_route进行注册
 * 
 * 1. fluro在这里完全是辅助作用(这里只是用到了跳转webview的widget),fluro和auto_route没有任何关联
 */

///使用fluro进行路由管理
class XRouter {
  static FluroRouter router;

  static void init() {
    router = FluroRouter();
    configureRoutes(router);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("route is not find !");
      return null;
    });

    //网页加载
    router.define('/web', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String title = params['title']?.first;
      String url = params['url']?.first;
      return WebViewPage(url, title);
    }));
  }

  static void navigateTo(BuildContext context, String path) {
    router.navigateTo(context, path, transition: TransitionType.inFromRight);
  }

  static void goWeb(BuildContext context, String url, String title) {
    navigateTo(context,
        "/web?url=${Uri.encodeComponent(url)}&title=${Uri.encodeComponent(title)}");
  }

  //=============AutoRoute===============//

  static ExtendedNavigatorState get navigator => ExtendedNavigator.root;

  // 跳转路由,且在路由队列中push,上一个路由会保存状态
  static void push(String routeName, {Map<String, String> queryParams}) {
    navigator.push(routeName, queryParams: queryParams);
  }

  // 跳转路由,将当前路由替换成指定路由
  static void replace(String routeName) {
    navigator.replace(routeName);
  }
}
