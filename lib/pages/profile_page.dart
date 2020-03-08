import 'package:bebro/common_widget/FlexibleDetailBar.dart';
import 'package:bebro/common_widget/my_list_tile.dart';
import 'package:bebro/config/maps.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/pages/update_userdetail_page.dart';
import 'package:bebro/state/global.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage(this.userId,{Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  User _user;
  TabController _tabController;
  PageController _pageController;
  bool _offLittleAvatar;
  ScrollController _scrollController;
  var _future;
  @override
  void initState() {
    _user =User();
    _future = _getUser();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _scrollController = ScrollController();
    _offLittleAvatar = true;
    var downLock = true;
    var upLock = false;
    _scrollController.addListener(() {
      //print(_scrollController.position.pixels);
      if (_scrollController.position.pixels > 140 && downLock) {
        setState(() {
          _offLittleAvatar = false;
        });
        upLock = true;
        downLock = false;
      }
      if (_scrollController.position.pixels < 140 && upLock) {
        setState(() {
          _offLittleAvatar = true;
        });
        upLock = false;
        downLock = true;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _buildScaffoldBody(),
    );
  }

  Widget _buildScaffoldBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + ScreenUtil().setHeight(115);
    return extended.NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: _headerSliverBuilder,
      pinnedHeaderSliverHeightBuilder: () {
        return pinnedHeaderHeight;
      },
      body: PageView(
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        controller: _pageController,
        children: <Widget>[
          Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => ListTile(
                title: Text("Item $index"),
              ),
              itemCount: 30,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(48),
                vertical: ScreenUtil().setHeight(40)),
            child: FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.connectionState == ConnectionState.done){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '信息资料',
                        style: textDisplayDq.copyWith(
                            fontSize: ScreenUtil().setSp(48),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Text('性别：'+gender[_user.gender]),
                      Text('生日：${_user.birthDay}'),
                      Text('城市：${_user.city.split('.')[1] ?? '未知'}'),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Text(
                        '个性签名',
                        style: textDisplayDq.copyWith(
                            fontSize: ScreenUtil().setSp(48),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Text(_user.bio?? '这个人很懒，什么都没写'),
                    ],
                  );
                }else{
                  return Center(
                    child: SpinKitCircle(color: Theme.of(context).primaryColor,),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[_sliverAppBar(context)];
  }

  Widget _sliverAppBar(BuildContext context) {
        return FutureBuilder(
          future: _future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return SliverAppBar(
                pinned: true,
                title: Offstage(
                  offstage: _offLittleAvatar,
                  child: Text(_user?.username ?? "用户${_user?.userId.toString()}", style: textDisplayDq),
                ),
                actions: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(24)),
                    child: IconButton(
                      icon: Icon(MyIcons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
                expandedHeight: ScreenUtil().setHeight(880),
                flexibleSpace: FlexibleDetailBar(
                  background: FlexShadowBackground(
                      child:Image(
                        image:_user.backImgUrl == null
                            ?AssetImage("images/back.jpg")
                            :NetworkImage(_user.backImgUrl),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,)),
                  content: Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(24),
                        right: ScreenUtil().setWidth(24),
                        top: ScreenUtil().setHeight(200)),
                    decoration: BoxDecoration(color: Colors.black26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyListTile(
                          height: 350,
                          leading: Container(
                              height: ScreenUtil().setHeight(210),
                              width: ScreenUtil().setHeight(210),
                              child: CircleAvatar(
                                  backgroundImage:_user.avatarUrl == null
                                      ? AssetImage("images/flutter_logo.png")
                                      : NetworkImage(_user.avatarUrl)
                              )),
                          trailing: Row(
                            children: <Widget>[
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) => UpdateUserDetailPage()));
                                  },
                                  color: Colors.white54,
                                  child: Text(
                                      '编辑资料',
                                      style: textDisplayDq.copyWith(color: Colors.white))
                              ),
                              SizedBox(width: ScreenUtil().setWidth(30)),
                              Container(
                                width: ScreenUtil().setWidth(110),
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  color: Colors.white54,
                                  child: Icon(MyIcons.qr_code, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil().setWidth(14),
                                top: ScreenUtil().setHeight(15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _user.username ?? "用户${_user.userId.toString()}",
                                  style: textDisplayDq.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ScreenUtil().setSp(58),
                                      color: Colors.white),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Text(_user.bio ?? '这个人很懒，什么都没写',
                                    style: textDisplayDq.copyWith(
                                        fontSize: ScreenUtil().setSp(42),
                                        color: Colors.white70)),
                                SizedBox(height: ScreenUtil().setHeight(20)),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      _user.followNum == null ? '0':_user.followNum.toString(),
                                      style: textDisplayArial.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(48)),
                                    ),
                                    Text(
                                      ' 关注',
                                      style: textDisplayDq.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(30),
                                    ),
                                    Text(
                                      _user.fanNum == null ? '0':_user.fanNum.toString(),
                                      style: textDisplayArial.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: ScreenUtil().setSp(48)),
                                    ),
                                    Text(
                                        ' 粉丝',
                                        style: textDisplayDq.copyWith(
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(ScreenUtil().setHeight(115)),
                  child: Container(
                    color: Colors.black26,
                    child: Container(
                      height: ScreenUtil().setHeight(115),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(ScreenUtil().setWidth(39)),
                            topRight: Radius.circular(ScreenUtil().setWidth(39)),
                          )),
                      child: TabBar(
                        onTap: (index) {
                          _pageController.jumpToPage(index);
                        },
                        controller: _tabController,
                        labelColor: Theme.of(context).primaryColor,
                        labelStyle: textDisplayDq.copyWith(fontWeight: FontWeight.bold),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Theme.of(context).primaryColorDark,
                        unselectedLabelStyle:
                        textDisplayDq.copyWith(fontWeight: FontWeight.w300),
                        tabs: <Widget>[
                          Text('动态'),
                          Text('详细资料'),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }else{
              return SliverAppBar(
                pinned: true,
                expandedHeight: ScreenUtil().setHeight(880),
                flexibleSpace: FlexibleDetailBar(
                  background: FlexShadowBackground(
                      child:Container(color: Color(0xfff3f3f3),)),
                  content: Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(24),
                        right: ScreenUtil().setWidth(24),
                        top: ScreenUtil().setHeight(200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        MyListTile(
                          height: 350,
                          leading: Container(
                              height: ScreenUtil().setHeight(210),
                              width: ScreenUtil().setHeight(210),
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(ScreenUtil().setHeight(115)),
                  child: Container(
                    height: ScreenUtil().setHeight(115),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(39)),
                          topRight: Radius.circular(ScreenUtil().setWidth(39)),
                        )),
                    child: TabBar(
                      onTap: (index) {_pageController.jumpToPage(index);},
                      controller: _tabController,
                      labelColor: Theme.of(context).primaryColor,
                      labelStyle: textDisplayDq.copyWith(fontWeight: FontWeight.bold),
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Theme.of(context).primaryColorDark,
                      unselectedLabelStyle:
                      textDisplayDq.copyWith(fontWeight: FontWeight.w300),
                      tabs: <Widget>[
                        Text('动态'),
                        Text('详细资料'),
                      ],
                    ),
                  ),
                ),
              );
            }
            }
        );
  }

  Future<void> _getUser() async {
    int askId = Global.profile.user.userId;
    var res = await NetRequester.request(Apis.findUserById(askId, widget.userId));
    _user = User.fromJson(res["data"]);
    if(widget.userId == askId){
      Global.profile.user =_user;
    }
  }
}
