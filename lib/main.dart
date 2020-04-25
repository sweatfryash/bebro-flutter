import 'dart:io';
import 'package:bebro/pages/HomeRoute.dart';
import 'package:bebro/pages/LoginPages/ForgetRoute.dart';
import 'package:bebro/pages/LoginPages/LoginRoute.dart';
import 'package:bebro/pages/LoginPages/RegisterRoute.dart';
import 'package:bebro/pages/post/send_post_page.dart';
import 'package:bebro/pages/openPic.dart';
import 'package:bebro/pages/setting_page.dart';
import 'package:bebro/pages/theme_change_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'pages/user/update_userdetail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final user = UserModel();
  final theme = ThemeModel();
  Global.init();
  //设置状态栏透明
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  //锁定竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  return runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserModel>.value(value: user),
          ChangeNotifierProvider<ThemeModel>.value(value: theme),
        ],
        child: MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
          dismissOtherOnShow: true,
          child: Consumer<ThemeModel>(
              builder: (BuildContext context, themeModel, _) {
            return MaterialApp(
              title: 'Be Bro',
              home: OpenPicRoute(),
              theme: themeModel.isDark
                  ? ThemeData(brightness: Brightness.dark)
                  : ThemeData(primarySwatch: themeModel.theme,
                  scaffoldBackgroundColor: Color(0xfff2f2f6)
              ),
              routes: {
                'register_page': (context) => RegisterRoute(),
                'home_page': (context) => HomeRoute(),
                'forget_page': (context) => ForgetRoute(),
                'login_page': (context) => LoginRoute(),
                'edit_msg_page': (context) => SendPostPage(type: 1),
                'theme_page': (context) => ThemeChangeRoute(),
                'setting_page': (context) => SettingPage(),
                'update_userdetail_page': (context) => UpdateUserDetailPage()
              },
            );
          }),
        );
  }
}
