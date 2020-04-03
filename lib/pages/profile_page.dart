import 'package:bebro/list_repository/post_repository.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/pages/chat_page.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/widget/FlexibleDetailBar.dart';
import 'package:bebro/widget/list_Indicator.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:bebro/config/maps.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/pages/qr_page.dart';
import 'package:bebro/pages/user/update_userdetail_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/widget/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  final String username;
  const ProfilePage({this.userId,Key key, this.username}) : super(key: key);
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
  PostRepository _postRepository;
  var _localUser=Global.profile.user;

  @override
  void initState() {
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
    _postRepository?.dispose();
    _tabController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder(
        future: _future,
          builder: (context, snap){
            if (snap.connectionState == ConnectionState.done) {
              if (snap.hasError) {
                return Center(
                  child: Text('加载失败，请重试',style: TextStyle(fontSize: ScreenUtil().setSp(48)),),
                );
              }else{
                return _buildScaffoldBody();
              }
            }else{
              return Center(
                child: SpinKitRing(
                  lineWidth: 3,
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
          }
      ),
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
          LoadingMoreList(
              ListConfig<Post>(
                itemBuilder: (BuildContext context, Post item, int index){
                  return PostCard(post: item,list: _postRepository,index: index);
                },
                sourceList: _postRepository,
                indicatorBuilder: _buildIndicator,
                padding: EdgeInsets.only(
                    top:ScreenUtil().setWidth(20),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20)
                ),
              ),
            ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(48),
                vertical: ScreenUtil().setHeight(40)),
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '信息资料',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Text('性别：'+gender[_user.gender]),
                      Text('生日：${_user.birthDay}'),
                      Text('城市：${!_user.city.contains('.')?'未知':_user.city.split('.')[1]}'),
                      SizedBox(height: ScreenUtil().setHeight(40)),
                      Text(
                        '个性签名',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(48),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Text(_user.bio?? '这个人很懒，什么都没写'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _postRepository);
  }
  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[_sliverAppBar(context)];
  }

  Widget _sliverAppBar(BuildContext context) {
              return SliverAppBar(
                pinned: true,
                title: Offstage(
                  offstage: _offLittleAvatar,
                  child: Text(_user?.username ?? "用户${_user?.userId.toString()}"),
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
                expandedHeight: 1080.h,
                flexibleSpace: FlexibleDetailBar(
                  background: FlexShadowBackground(
                      child:Image(
                        image:_user.backImgUrl == null
                            ?AssetImage("assets/images/back.jpg")
                            :NetworkImage(_user.backImgUrl),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,)),
                  content: Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(44),
                        right: ScreenUtil().setWidth(24)),
                    decoration: BoxDecoration(color: Colors.black26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(flex: 8,child: Container(),),
                        MyListTile(
                          leading: Container(
                              height: 270.h,
                              width: 270.h,
                              child: CircleAvatar(
                                  backgroundImage:_user.avatarUrl == null
                                      ? AssetImage("assets/images/flutter_logo.png")
                                      : NetworkImage(_user.avatarUrl)
                              )),
                          trailing: Row(
                            children: <Widget>[
                              FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  onPressed: _user.userId==_localUser.userId?() {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) => UpdateUserDetailPage()));
                                  }:() async {
                                    var fanId = Global.profile.user.userId;
                                    var res = await NetRequester.request(
                                        _user.isFollow==0?Apis.followAUser(fanId, _user.userId)
                                            :Apis.cancelFollowAUser(fanId, _user.userId));
                                    if(res['code'] =='1'){
                                      setState(() {
                                        _user.isFollow= _user.isFollow==1?0:1;
                                      });
                                      _user.isFollow==1
                                          ?Global.profile.user.followNum++
                                          :Global.profile.user.followNum--;
                                      UserModel().notifyListeners();
                                    }
                                  },
                                  color: _user.userId==_localUser.userId ||_user.isFollow==1
                                      ?Colors.white54:Theme.of(context).primaryColor,
                                  child: Text(
                                      _user.userId==_localUser.userId
                                          ?'编辑资料':_user.isFollow==1?'已关注':'关注',
                                      style: TextStyle(color: Colors.white))
                              ),
                              SizedBox(width: ScreenUtil().setWidth(30)),
                              Container(
                                width: ScreenUtil().setWidth(110),
                                child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  color: Colors.white54,
                                  child: Icon(_user.userId==_localUser.userId
                                      ?MyIcons.qr_code
                                      :AntDesign.mail, color: Colors.white),
                                  onPressed: () {
                                    Navigator.push(context,
                                        CupertinoPageRoute(builder: (context) =>
                                        _user.userId==_localUser.userId
                                            ?QrPage(user: _user,)
                                            :ChatPage(user: _user,)));}

                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 1,child: Container(),),
                        Text(
                          _user.username ?? "用户${_user.userId.toString()}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(66),
                              color: Colors.white),
                        ),
                        Expanded(flex: 1,child: Container(),),
                        Text(_user.bio ?? '这个人很懒，什么都没写',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(42),
                                color: Colors.white70)),
                        Expanded(flex: 1,child: Container(),),
                        Row(
                          children: <Widget>[
                            Text(
                              _user.followNum == null ? '0':_user.followNum.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(50)),
                            ),
                            Text(
                              ' 关注  ',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              _user.fanNum == null ? '0':_user.fanNum.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(50)),
                            ),
                            Text(' 粉丝', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        Expanded(flex: 1,child: Container(),),
                        infoRow(),
                        Expanded(flex: 3,child: Container(),),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(ScreenUtil().setHeight(102)),
                  child: Consumer<ThemeModel>(
                    builder:  (BuildContext context, themeModel, _) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(39)),
                          topRight: Radius.circular(ScreenUtil().setWidth(39)),
                        )),
                        elevation: 1,
                        margin: EdgeInsets.all(0),
                        child: TabBar(
                          onTap: (index) {
                            _pageController.jumpToPage(index);
                          },
                          controller: _tabController,
                          labelColor: Theme.of(context).accentColor,
                          unselectedLabelColor: themeModel.isDark?Colors.white:Colors.grey,
                          indicatorSize: TabBarIndicatorSize.label,
                          //indicatorColor: Theme.of(context).primaryColorDark,
                          unselectedLabelStyle:
                          TextStyle(fontWeight: FontWeight.w300),
                          tabs: <Widget>[
                            Tab(text:'动态'),
                            Tab(text:'详细资料'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );

  }

  Row infoRow() {
    return Row(
      children: <Widget>[
        Offstage(
          offstage: _user.gender == 2,
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(4),
            horizontal: ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
                color: _user.gender == 1
                    ?Colors.blue[300].withOpacity(0.7)
                    :Colors.pink[300].withOpacity(0.7),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
            ),
            child: Row(
              children: <Widget>[
                Icon(_user.gender == 0
                    ?Ionicons.md_female
                    :Ionicons.md_male,
                  size: ScreenUtil().setWidth(35),
                  color: Colors.white,
                ),
                Offstage(
                    offstage: _user.birthDay == ''||_user.birthDay==null,
                    child: Text(' '+ageBuilder()+'岁',style: TextStyle(fontSize: ScreenUtil().setSp(33)),)),
              ],
            ),
          ),
        ),
        Offstage(
          offstage: _user.city == ''||_user.city==null,
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(4),
            horizontal: ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
                color: Colors.white54,
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
            ),
            child: Text(_user.city == ''||_user.city==null?'':_user.city?.split('.')[1],
              style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
          ),
        ),
        Offstage(
          offstage: _user.birthDay == ''||_user.birthDay==null,
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(2),
            horizontal: ScreenUtil().setWidth(20)),
            decoration: BoxDecoration(
                color: Colors.white54,
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30))
            ),
            child: Text(starSign(),style: TextStyle(fontSize: ScreenUtil().setSp(33)),),
          ),
        ),

      ],
    );
  }

  Future<void> _getUser() async {
    int askId = _localUser.userId;
    var res;
    if(widget?.userId != null){
       res = await NetRequester.request(Apis.findUserById(askId, widget.userId));
    }else{
       res = await NetRequester.request(Apis.findUserByName(askId, widget.username));
    }
    if(res['code'] == '0'){
      Toast.popToast('用户不存在');
      Future.delayed(Duration(milliseconds: 500), (){
        Navigator.pop(context);
      });
    }else{
      _user = User.fromJson(res["data"]);
      _postRepository =  PostRepository(_user.userId,1);
      if(widget?.userId == askId || widget?.username == _localUser.username){
        Global.profile.user =_user;
        UserModel().notifyListeners();
      }
    }

  }

  String ageBuilder(){
    var date = DateTime.parse(_user.birthDay);
    var now =DateTime.now();
    var age = now.year - date.year;
    return age.toString();
  }

  String starSign() {
    var birthDay = DateTime.parse(_user.birthDay);
    var month = birthDay.month;
    var day = birthDay.day;
    String starSign = '';
    switch (month)
    {
    case 1:
      starSign=day<21?'摩羯座':'水瓶座';
      break;
    case 2:
      starSign=day<20? '水瓶座':'双鱼座';
      break;
    case 3:
      starSign=day<21?'双鱼座':'白羊座';
      break;
    case 4:
      starSign=day<21?'白羊座':'金牛座';
      break;
    case 5:
      starSign=day<22?'金牛座':'双子座';
      break;
    case 6:
      starSign=day<22?'双子座':'巨蟹座';
      break;
    case 7:
      starSign=day<23?'巨蟹座':'狮子座';
      break;
    case 8:
      starSign=day<24?'狮子座':'处女座';
      break;
    case 9:
      starSign=day<24?'处女座':'天秤座';
      break;
    case 10:
      starSign=day<24?'天秤座':'天蝎座';
      break;
    case 11:
      starSign=day<23?'天蝎座':'射手座';
      break;
    case 12:
      starSign=day<22?'射手座':'摩羯座';
      break;
  }
  return starSign;
  }
}
