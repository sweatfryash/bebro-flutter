import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:bebro/pages/post/feed_page.dart';
import 'package:bebro/util/check_update.dart';
import 'package:bebro/pages/post/hot_page.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'post/send_post_page.dart';
import 'me_page.dart';
import 'notifiction.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => new _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _pageList = List(); //列表存放页面
  int _selectedIndex; //bar下标
  bool _hadCheckUpdate;

  PageController _pageController;

  @override
  initState() {
    super.initState();
    _hadCheckUpdate = false;
    _selectedIndex = 0;
    _pageController = PageController();
    //初始化页面列表
    _pageList
      ..add(FeedPage())
      ..add(HotPage())
      ..add(SendPostPage(type: 1))
      ..add(MessageScreen())
      ..add(MePage());
  }

  @override
  Widget build(BuildContext context) {
    if(!_hadCheckUpdate){
      CheckoutUpdateUtil.checkUpdate(context);
      _hadCheckUpdate = true;
    }
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
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
              title: Text('关注'),
              activeIcon:
                  Icon(MyIcons.home_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                MyIcons.explore,
                size: ScreenUtil().setWidth(75),
              ),
              title: Text('发现'),
              activeIcon:
                  Icon(MyIcons.explore_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: ScreenUtil().setWidth(140),
                height: ScreenUtil().setWidth(90),
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
              title: Text('通知'),
              activeIcon:
                  Icon(MyIcons.bell_fill, size: ScreenUtil().setWidth(75)),
            ),
            BottomNavigationBarItem(
              icon: Icon(MyIcons.user, size: ScreenUtil().setWidth(75)),
              title: Text('我'),
              activeIcon:
                  Icon(MyIcons.user_fill, size: ScreenUtil().setWidth(75)),
            ),
          ],
          backgroundColor: Theme.of(context).bottomAppBarColor,
          activeColor: Theme.of(context).accentColor,
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
