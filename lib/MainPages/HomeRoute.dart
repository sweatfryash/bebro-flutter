import 'package:bebro/CommonWidget/MyDrawer.dart';
import 'package:bebro/MainPages/timeline_page.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'follow.dart';
import 'message.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => new _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pageList = List(); //列表存放页面
  List<String> titleList = List();
  int _selectedIndex = 0; //bar下标
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

  @override
  initState() {
    super.initState();
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
    pageList..add(TimelineOnePage())..add(MessageScreen())..add(FollowScreen());
    titleList..add("首页")..add("消息")..add("关注");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(titleList[_selectedIndex]),
      ),
      drawer: MyDrawer(
        widthPercent: 0.75,
        child: Column(
          children: <Widget>[
            Consumer<UserModel>(builder: (BuildContext context, userModel, _) {
              return UserAccountsDrawerHeader(
                accountName: Text(
                  userModel.user.username,
                  textScaleFactor: 1.4,
                ),
                accountEmail: Text(userModel.user.bio),
                currentAccountPicture: CircleAvatar(
                    child: CachedNetworkImage(
                      imageUrl: userModel.user.avatarUrl,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                ),
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
                              opacity: ReverseAnimation(_drawerContentsOpacity),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    title: const Text('修改信息'),
                                    onTap: (){
                                      Navigator.pushNamed(context, 'update_userdetail_page');
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                        Icons.power_settings_new),
                                    title: const Text('退出登录'),
                                    onTap: () async {
                                      //跳转到登录界面并把accountCode清除
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          'login_page',
                                          (route) => route == null);
                                      SharedPreferences _prefs =
                                          await SharedPreferences.getInstance();
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
      body: pageList[_selectedIndex],
      bottomNavigationBar: BottomNavyBar(
        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.timeline),
              title: Text('首页'),
              activeColor: Theme.of(context).accentColor),
          BottomNavyBarItem(
              icon: Icon(Icons.email),
              title: Text('消息'),
              activeColor: Theme.of(context).accentColor),
          BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text('关注'),
              activeColor: Theme.of(context).accentColor),
        ],
        showElevation: false,
        selectedIndex: _selectedIndex,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }
}
