import 'package:bebro/common_widget/my_appbar.dart';
import 'package:bebro/common_widget/my_list_tile.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: MyAppbar.build(Text(
        '通知',
        style: textDisplayDq,
      )),
      body: ListView(
        children: <Widget>[
          MyListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(
                MyIcons.like,
                color: Colors.white,
              ),
              maxRadius: 40.0,
            ),
            center: Text(
              '收到的赞',
              style: textDisplayDq.copyWith(fontSize: ScreenUtil().setSp(48)),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          MyListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(
                MyIcons.comment,
                color: Colors.white,
              ),
              maxRadius: 40.0,
            ),
            center: Text(
              '收到的评论',
              style: textDisplayDq.copyWith(fontSize: ScreenUtil().setSp(48)),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          MyListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(
                MyIcons.comment,
                color: Colors.white,
              ),
              maxRadius: 40.0,
            ),
            center: Text(
              '好友关注',
              style: textDisplayDq.copyWith(fontSize: ScreenUtil().setSp(48)),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
