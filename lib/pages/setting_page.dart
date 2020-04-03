import 'package:bebro/pages/about_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/pages/user/update_userdetail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(-8),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(40)),
          MyListTile(
            left: 40,
            leading: Text(
              '头像与个人信息',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              MyIcons.right, size: ScreenUtil().setWidth(50), color: Colors.grey
            ),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => UpdateUserDetailPage()));
            },
          ),
          Divider(indent: ScreenUtil().setWidth(40)),
          MyListTile(
            left: 40,
            leading: Text(
              '缓存清理',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          MyListTile(
            left: 40,
            leading: Text(
              '关于',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(48),
                  fontWeight: FontWeight.w500),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => AboutPage()));
            },
          ),
          Divider(indent: ScreenUtil().setWidth(40)),
          FlatButton(
            onPressed: () async {
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _prefs.remove('profile');
              Navigator.pushNamedAndRemoveUntil(context, 'login_page', (route) => route == null);
            },
            child: Text(
              '退出登录',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: ScreenUtil().setSp(54),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
