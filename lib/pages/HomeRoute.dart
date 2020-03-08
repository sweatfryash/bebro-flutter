import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:bebro/pages/feed_page.dart';
import 'package:bebro/common_widget/MyDrawer.dart';
import 'package:bebro/pages/hot_page.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_msg_route.dart';
import 'me_page.dart';
import 'message.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => new _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _pageList = List(); //列表存放页面
  int _selectedIndex; //bar下标
  //动画
  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;
  PageController _pageController;

  @override
  initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
    //初始化页面列表
    _pageList
      ..add(FeedPage())
      ..add(HotPage())
      ..add(EditRoute())
      ..add(MessageScreen())
      ..add(MePage());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MyDrawer(
          widthPercent: 0.75,
          child: Column(
            children: <Widget>[
              Consumer<UserModel>(
                  builder: (BuildContext context, userModel, _) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    userModel.user.username,
                    textScaleFactor: 1.4,
                  ),
                  accountEmail: Text(userModel.user.bio),
                  onDetailsPressed: () async {
                    _showDrawerContents = !_showDrawerContents;
                    if (_showDrawerContents)
                      _controller.reverse();
                    else
                      _controller.forward();
                  },
                );
              }),
              MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 8.0),
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            FadeTransition(
                              opacity: _drawerContentsOpacity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ListTile(
                                      title: Text('我的收藏'),
                                      leading: Icon(Icons.star)),
                                  ListTile(
                                      title: Text('主题风格'),
                                      leading: Icon(Icons.color_lens),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, 'theme_page');
                                      }),
                                  Consumer<ThemeModel>(builder:
                                      (BuildContext context, themeModel, _) {
                                    return ListTile(
                                      title: Text('夜间模式'),
                                      leading: Icon(Icons.brightness_2),
                                      trailing: Switch(
                                        value: themeModel.isDark,
                                        onChanged: (bool b) {
                                          themeModel.isDark = b;
                                        },
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                            SlideTransition(
                              position: _drawerDetailsPosition,
                              child: FadeTransition(
                                opacity:
                                    ReverseAnimation(_drawerContentsOpacity),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.person),
                                      title: const Text('修改信息'),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, 'update_userdetail_page');
                                      },
                                    ),
                                    ListTile(
                                      leading:
                                          const Icon(Icons.power_settings_new),
                                      title: const Text('退出登录'),
                                      onTap: () async {
                                        //跳转到登录界面并把accountCode清除
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'login_page',
                                            (route) => route == null);

                                        SharedPreferences _prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        _prefs.remove('profile');
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _pageList,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                MyIcons.home,
                size: ScreenUtil().setWidth(75),
              ),
              title: Text(
                '关注',
                style: textDisplayDq,
              ),
              activeIcon:
                  Icon(MyIcons.home_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyIcons.explore,
                size: ScreenUtil().setWidth(75),
              ),
              title: Text(
                '发现',
                style: textDisplayDq,
              ),
              activeIcon:
                  Icon(MyIcons.explore_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: ScreenUtil().setWidth(140),
                height: ScreenUtil().setHeight(80),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(ScreenUtil().setWidth(45)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Icon(MyIcons.plus,
                    color: Colors.white, size: ScreenUtil().setWidth(66)),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(MyIcons.bell, size: ScreenUtil().setWidth(75)),
              title: Text('通知', style: textDisplayDq),
              activeIcon:
                  Icon(MyIcons.bell_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Icon(MyIcons.user, size: ScreenUtil().setWidth(75)),
              title: Text('我', style: textDisplayDq),
              activeIcon:
                  Icon(MyIcons.user_fill, size: ScreenUtil().setWidth(75)),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: onTap,
        ),
      ),
    );
  }

  Future<bool> _dialogExitApp(BuildContext context) async {
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }
    return Future.value(false);
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future onTap(int index) async {
    if (index == 2) {
      Navigator.pushNamed(context, 'edit_msg_page');
    } else {
      _pageController.jumpToPage(index);
    }
  }
}
