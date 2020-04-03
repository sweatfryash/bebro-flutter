import 'package:bebro/widget/my_appbar.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.build(context,Text('通知')),
      body: ListView(
        children: <Widget>[
          MyListTile(
            crossAxis: CrossAxisAlignment.center,
            leading: Container(
              height: ScreenUtil().setWidth(150),
              child: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Icon(
                  MyIcons.like,
                  color: Colors.white,
                ),
                maxRadius: 40.0,
              ),
            ),
            center: Text(
              '收到的赞',
              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          MyListTile(
            crossAxis: CrossAxisAlignment.center,
            leading: Container(
              height: ScreenUtil().setWidth(150),
              child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  MyIcons.comment,
                  color: Colors.white,
                ),
                maxRadius: 40.0,
              ),
            ),
            center: Text(
              '收到的评论',
              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
            onTap: () {},
          ),
          MyListTile(
            crossAxis: CrossAxisAlignment.center,
            leading: Container(
              height: ScreenUtil().setWidth(150),
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(
                  MyIcons.comment,
                  color: Colors.white,
                ),
                maxRadius: 40.0,
              ),
            ),
            center: Text(
              '好友关注',
              style: TextStyle(fontSize: ScreenUtil().setSp(48)),
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
