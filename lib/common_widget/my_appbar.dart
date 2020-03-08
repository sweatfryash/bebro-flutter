import 'package:bebro/config/my_icon.dart';
import 'package:bebro/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppbar {
  static Widget build(Widget title) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
          child: IconButton(
            icon: Icon(
              MyIcons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Toast.popLoading('正在上传');
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
}
