import 'package:bebro/pages/LoginPages/LoginRoute.dart';
import 'package:bebro/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeRoute.dart';

class OpenPicRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpenPicRouteState();
}

class _OpenPicRouteState extends State<OpenPicRoute> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,width: 1080, height: 2232);
    print('设备宽度:${ScreenUtil.screenWidth}');
    print('设备高度:${ScreenUtil.screenHeight}');
    print('设备的像素密度:${ScreenUtil.pixelRatio}');
    print('实际宽度的dp与设计稿px的比例:${ScreenUtil().scaleWidth}');
    print('实际高度的dp与设计稿px的比例:${ScreenUtil().scaleHeight}');
    print(
        '宽度和字体相对于设计稿放大的比例:${ScreenUtil().scaleWidth * ScreenUtil.pixelRatio}');
    print('高度相对于设计稿放大的比例:${ScreenUtil().scaleHeight * ScreenUtil.pixelRatio}');
    return GestureDetector(
        onTap: goToHomePage,
        child: Material(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(300),
                    child: Image.asset("assets/images/flutter_logo.png",)
                ),
                SizedBox(height: ScreenUtil().setHeight(120),),
                Text("BeBro",style: TextStyle(
                  //color: Theme.of(context).primaryColor,
                    fontSize: ScreenUtil().setSp(150),
                fontFamily: 'chocolate'),),
              ],
            ),
          ),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

  void countDown() {
    //设置倒计时三秒后执行跳转方法
    var duration = new Duration(seconds: 3);
    Future.delayed(duration, goToHomePage);
  }

  Future goToHomePage() async {
    if(mounted){
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
}
