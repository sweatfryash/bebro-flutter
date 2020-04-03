import 'package:bebro/pages/post/my_post_page.dart';
import 'package:bebro/pages/post/star_page.dart';
import 'package:bebro/pages/profile_page.dart';
import 'package:bebro/pages/scan_camera_page.dart';
import 'package:bebro/pages/setting_page.dart';
import 'package:bebro/pages/user/fans_page.dart';
import 'package:bebro/pages/user/follow_page.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:bebro/widget/param_config.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/pages/qr_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:r_scan/r_scan.dart';

class MePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MePageState();
  }
}

class _MePageState extends State<MePage> with AutomaticKeepAliveClientMixin {
  bool _offLittleAvatar;
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _offLittleAvatar = true;
    var downLock = true;
    var upLock = false;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 70 && downLock) {
        setState(() {
          _offLittleAvatar = false;
        });
        upLock = true;
        downLock = false;
      }
      if (_scrollController.position.pixels < 70 && upLock) {
        setState(() {
          _offLittleAvatar = true;
        });
        upLock = false;
        downLock = true;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Offstage(
          offstage: _offLittleAvatar,
          child: Container(
            width: ScreenUtil().setWidth(90),
            height: ScreenUtil().setWidth(90),
            child: CircleAvatar(
              backgroundImage: Global.profile.user?.avatarUrl ==null
                  ? AssetImage("assets/images/flutter_logo.png")
                  : NetworkImage(Global.profile.user.avatarUrl),
            ),
          ),
        ),
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(-8),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MyIcons.scan,
              color: Colors.white,
            ),
            onPressed: () async {
              rScanCameras= await availableRScanCameras();
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => RScanCameraDialog()));
            },
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
            child: IconButton(
              icon: Icon(
                MyIcons.setting,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => SettingPage()));
              },
            ),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          _buildShowUserInfo(),
          _buildFunGrid(),
          _buildHistory(),
        ],
      ),
    );
  }

  //页面上方的显示用户信息的那一块儿
  Widget _buildShowUserInfo() {
    return Consumer<UserModel>(builder: (BuildContext context, model, _) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).scaffoldBackgroundColor
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        height: ScreenUtil().setHeight(450),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => ProfilePage(userId:model.user.userId)));
              },
              child: Container(
                margin:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
                height: ScreenUtil().setHeight(230),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //头像和昵称
                    Row(
                      children: <Widget>[
                        Container(
                          height: 230.h,
                          width: 230.h,
                          child: CircleAvatar(
                            backgroundImage:
                            Global.profile.user.avatarUrl ==null
                                ? AssetImage("assets/images/flutter_logo.png")
                                : NetworkImage(Global.profile.user.avatarUrl),
                          ),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(30),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              model.user.username ?? "用户${model.user.userId.toString()}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: ScreenUtil().setSp(66)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(30),
                            ),
                            Text(
                              model.user.bio ?? '这人很懒，什么也没写',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(36)),
                            ),
                            SizedBox(
                              height: ScreenUtil().setHeight(15),
                            ),
                          ],
                        )
                      ],
                    ),
                    //二维码和箭头
                    Row(
                      children: <Widget>[
                        //二维码按钮
                        Container(
                          width: ScreenUtil().setWidth(110),
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              MyIcons.qr_code,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) =>
                                      QrPage(user: model.user,)));
                            },
                          ),
                        ),
                        //箭头按钮
                        Container(
                          width: ScreenUtil().setWidth(70),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(44),
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.all(0),
                            child: Icon(
                              MyIcons.right,
                              color: Colors.white,
                              size: ScreenUtil().setWidth(50),
                            ),
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
              margin:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(24)),
              child: Container(
                height: 180.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildShowNum(model.user.postNum == null
                        ? '0':model.user.postNum.toString(),
                        '动态',MyPostPage()),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300], width: 0.5))),
                    _buildShowNum(model.user.followNum == null
                        ? '0':model.user.followNum.toString(), '关注',FollowPage()),
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300], width: 0.5)),
                    ),
                    _buildShowNum(model.user.fanNum == null
                        ? '0':model.user.fanNum.toString(), '粉丝',FansPage()),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  //显示动态数量等的小部件
  Widget _buildShowNum(String num, String label,Widget page) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => page));
      },
      child: Container(
        height: ScreenUtil().setHeight(150),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(num.length < 4 ? num : '999+',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(60),
                    fontWeight: FontWeight.w600)),
            Text(label,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(36), color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildFunGrid() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(24),
          vertical: ScreenUtil().setHeight(30)),
      child: Container(
        height: 180.h,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildGridItem(
                    Icon(
                      MyIcons.star,
                      color: Colors.blueAccent,
                    ),
                    '我的收藏',
                    () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => StarPage()));
                    }),
                _buildGridItem(
                    Icon(
                      MyIcons.skin,
                      color: Colors.pinkAccent,
                    ),
                    '主题风格', () {
                  Navigator.pushNamed(context, 'theme_page');
                }),
                Consumer<ThemeModel>(
                    builder: ( context, themeModel, _) {
                  return _buildGridItem(
                      Icon(themeModel.isDark
                          ?Ionicons.md_sunny:MyIcons.moon, color: Colors.purpleAccent),
                      themeModel.isDark
                          ?'日间模式':'夜间模式',
                      () {
                        themeModel.isDark=!themeModel.isDark;
                      });}
                ),
                _buildGridItem(
                    Icon(
                      MyIcons.and_more,
                      color: Colors.orangeAccent,
                    ),
                    '更多',
                    () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(Icon icon, String label, Function function) {
    return Container(
      width: ScreenUtil().setWidth(255),
      child: FlatButton(
        padding: EdgeInsets.symmetric(horizontal: 0),
        onPressed: function,
        child: Column(
          children: <Widget>[
            icon,
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Text(label)
          ],
        ),
      ),
    );
  }

  Widget _buildHistory() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(24),
          vertical: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          MyListTile(
            left: 30,
            leading: Text(
              '浏览历史',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(54)),
            ),
            trailing: Icon(
              MyIcons.right,
              size: ScreenUtil().setWidth(50),
              color: Colors.grey,
            ),
          ),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
          _buildHistoryItem(),
        ],
      ),
    );
  }

  Widget _buildHistoryItem() {
    return MyListTile(
      left: 40,
      leading: Container(
        width: ScreenUtil().setWidth(150),
        height: ScreenUtil().setWidth(150),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
        ),
      ),
      center: Container(
        width: ScreenUtil().setWidth(759),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '兰兰' + '的动态',
                  style:
                  TextStyle(fontSize: ScreenUtil().setSp(54)),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '2小时前',
                  style: TextStyle(
                      color: Colors.grey, fontSize: ScreenUtil().setSp(38)),
                ),
              ],
            ),
            Text(
              '如果让你重新来过，你会不会爱我，爱情让人感到快乐',
              style: TextStyle(
                  color: Colors.grey, fontSize: ScreenUtil().setSp(40)),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
