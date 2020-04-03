import 'package:bebro/config/my_icon.dart';
import 'package:bebro/pages/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppbar {
  static Widget build(BuildContext context,Widget title) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title,
      elevation: 1,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
          child: IconButton(
            icon: Icon(
              MyIcons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SearchPage()));
            },
          ),
        ),
      ],
      bottom: PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(-8),
      ),
    );
  }
  static Widget simpleAppbar(String title){
    return AppBar(
      title: Text(title),
      elevation: 1,
      bottom: PreferredSize(
        child: Container(),
        preferredSize: Size.fromHeight(-8),
      ),
    );
  }
}
