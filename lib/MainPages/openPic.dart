import 'package:bebro/LoginPages/LoginRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeRoute.dart';

class OpenPicRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpenPicRouteState();
}

class _OpenPicRouteState extends State<OpenPicRoute> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: goToHomePage,
        child: //Image.network('http://112.74.169.4:8080/images/open-pic.png'),
            Image(
          image: AssetImage("images/flutter_logo.png"),
        ));
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

  void countDown() {
    //设置倒计时三秒后执行跳转方法
    var duration = new Duration(seconds: 3);
    new Future.delayed(duration, goToHomePage);
  }

  Future goToHomePage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //如果页面还未跳转过则跳转页面
    if (_prefs.getString('profile') != null) {
      //跳转主页 且销毁当前页面
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => HomeRoute()),
          (Route<dynamic> rout) => false);
    } else {
      //跳转登录页 且销毁当前页面
      Navigator.of(context).pushAndRemoveUntil(
          new MaterialPageRoute(builder: (context) => LoginRoute()),
          (Route<dynamic> rout) => false);
    }
  }
}
