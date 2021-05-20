import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tutu/core/http/http.dart';
import 'package:tutu/core/utils/toast.dart';
import 'package:tutu/generated/i18n.dart';
import 'package:tutu/router/route_map.dart';
import 'package:tutu/router/route_map.gr.dart';
import 'package:tutu/router/router.dart';
import 'package:tutu/utils/provider.dart';
import 'package:tutu/utils/sputils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//默认App的启动
class DefaultApp {
  //运行app
  static void run() {
    WidgetsFlutterBinding.ensureInitialized();
    SPUtils.init()
        .then((value) => runApp(Store.init(ToastUtils.init(MyApp()))));
    initApp();
  }

  //程序初始化操作
  static void initApp() {
    XHttp.init();
    XRouter.init();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppTheme, LocaleModel>(
        builder: (context, appTheme, localeModel, _) {
      return ScreenUtilInit(
          designSize: Size(750, 1334),
          builder: () => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Project',
                theme: ThemeData(
                  primarySwatch: appTheme.themeColor,
                  buttonColor: appTheme.themeColor,
                ),
                builder: ExtendedNavigator<RouterMap>(
                  router: RouterMap(),
                  guards: [AuthGuard()],
                ),
                locale: localeModel.getLocale(),
                supportedLocales: I18n.delegate.supportedLocales,
                localizationsDelegates: [
                  I18n.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback:
                    (Locale _locale, Iterable<Locale> supportedLocales) {
                  if (localeModel.getLocale() != null) {
                    //如果已经选定语言，则不跟随系统
                    return localeModel.getLocale();
                  } else {
                    //跟随系统
                    if (I18n.delegate.isSupported(_locale)) {
                      return _locale;
                    }
                    return supportedLocales.first;
                  }
                },
              ));
    });
  }
}
