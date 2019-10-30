import 'package:bebro/LoginPages/ForgetRoute.dart';
import 'package:bebro/LoginPages/LoginRoute.dart';
import 'package:bebro/LoginPages/RegisterRoute.dart';
import 'package:bebro/MainPages/HomeRoute.dart';
import 'package:bebro/MainPages/edit_msg_route.dart';
import 'package:bebro/MainPages/openPic.dart';
import 'package:bebro/MainPages/theme_change_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/state/postList_change_notifier.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MainPages/update_userdetail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init();
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <SingleChildCloneableWidget>[
          ChangeNotifierProvider.value(value: ThemeModel()),
          ChangeNotifierProvider.value(value: UserModel()),
          ChangeNotifierProvider.value(value: PostListModel()),
        ],
        child: Consumer<ThemeModel>(
            builder: (BuildContext context, themeModel, _) {
          return MaterialApp(
            title: 'Be Bro',
            home: OpenPicRoute(),
            theme: themeModel.isDark
                ? ThemeData.dark()
                : ThemeData(primarySwatch: themeModel.theme), //getTheme(themeModel),
            routes: {
              'register_page': (context) => RegisterRoute(),
              'home_page': (context) => HomeRoute(),
              'forget_page': (context) => ForgetRoute(),
              'login_page': (context) => LoginRoute(),
              'edit_msg_page': (context) => EditRoute(),
              'theme_page': (context) => ThemeChangeRoute(),
              'update_userdetail_page':(context)=>UpdateUserDetailPage()
            },
          );
        }));
  }

  ThemeData getTheme(ThemeModel themeModel) {
    ThemeData a = themeModel.isDark
        ? ThemeData.dark()
        : ThemeData(primarySwatch: themeModel.theme);
    return a;
  }
}
