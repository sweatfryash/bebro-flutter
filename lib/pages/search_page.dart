import 'package:bebro/config/my_icon.dart';
import 'package:bebro/pages/post/common_post_page.dart';
import 'package:bebro/pages/user/common_user_page.dart';
import 'package:bebro/state/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>  with TickerProviderStateMixin {
  TextEditingController _editingController =TextEditingController();
  TabController _tabController;
  PageController _pageController;
  bool _showTabBar;
  String str;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);

    _showTabBar=false;
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _pageController = PageController(initialPage: _tabController.index);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        title: _searchBar(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_showTabBar?25:-8),
          child: _showTabBar
              ?Container(
            height: 33,
            child: TabBar(
              onTap: (index){
                _pageController.jumpToPage(index);
              },
              labelPadding: EdgeInsets.only(bottom: ScreenUtil().setHeight(18)),
              controller: _tabController,
              tabs: <Widget>[
                Tab(text: '热门'),
                Tab(text: '用户'),
                Tab(text: '关注'),
                Tab(text: '实时'),
              ],
            ))
              :Container()
        ),
      ),
      body: _showTabBar?PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index);
        },
        children: <Widget>[
          CommonPostPage(type: 7,orderBy: 'hot',str: str),
          CommonUserPage(str: str),
          CommonPostPage(type: 8,str: str),
          CommonPostPage(type: 7,orderBy: 'postId',str: str),
        ],
      ):_buildSearchHistory(),
    );
  }

  Container _searchBar() {
    return Container(
        height: 90.h,
        child: Stack(
          children: <Widget>[
            CupertinoTextField(
              onEditingComplete: (){
                sendHandler();
              },
                onTap: (){
                setState(() {
                  _showTabBar = false;
                });
                },
              focusNode: _focusNode,
              controller: _editingController,
              autofocus: true,
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0)),
              textInputAction: TextInputAction.search,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: ScreenUtil().setSp(44)),
                prefix: Container(
                  width: ScreenUtil().setWidth(140),
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(AntDesign.arrowleft,size: ScreenUtil().setWidth(60),
                    color: Colors.white.withOpacity(0.8),),
                  ),
                ),
                placeholder: '搜索用户和动态',
                placeholderStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                fontSize: ScreenUtil().setSp(44)),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(21)
                )
            ),
            Positioned(
              right: ScreenUtil().setWidth(5),
              child:Container(
                width: ScreenUtil().setWidth(160),
                height: ScreenUtil().setHeight(80),
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: (){
                    sendHandler();
                  },
                  icon: Icon(MyIcons.search,size: ScreenUtil().setWidth(60),
                    color: Colors.white.withOpacity(0.8),),
                ),
              ),
            ),
          ],
        ),
      );
  }

  void sendHandler() {
    if(_editingController.text!='' &&_editingController.text!=null ){
      _focusNode.unfocus();
      setState(() {
        _showTabBar = true;
        str = _editingController.text;
        if(Global.profile.searchList.contains(str)){
          Global.profile.searchList.remove(str);
          Global.profile.searchList.insert(0, str);
        }else{
          Global.profile.searchList.insert(0,str);
        }
        Global.saveProfile();
      });
    }
  }

  _buildSearchHistory(){
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(42),
          vertical: ScreenUtil().setHeight(40)),
        child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('搜索历史',style: TextStyle(fontSize: ScreenUtil().setSp(44))),
              FlatButton.icon(
                  onPressed: (){
                    Global.profile.searchList.clear();
                    Global.saveProfile();
                    setState(() {
                    });
                  },
                  icon: Icon(AntDesign.delete,color: Colors.grey,
                    size: ScreenUtil().setWidth(45),),
                  label: Text('清除',style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(36)),))
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Global.profile.searchList.isEmpty
              ?Container()
              :Wrap(
            spacing: ScreenUtil().setWidth(20),
            children: List<Widget>.generate(
              Global.profile.searchList.length,
                  (int index) {
                return _buildItem(index);
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  _buildItem(int index) {
    String content = Global.profile.searchList[index];
    return ActionChip(
      label: Text(content,style: TextStyle(fontSize: ScreenUtil().setSp(36))),
      backgroundColor: Colors.black.withOpacity(0.1),
      labelPadding: EdgeInsets.symmetric(vertical:0,horizontal: ScreenUtil().setWidth(20)),
      onPressed: (){
        _focusNode.unfocus();
          setState(() {
            _showTabBar = true;
            str = content;
            _editingController.text=content;
            Global.profile.searchList.removeAt(index);
            Global.profile.searchList.insert(0, str);
            Global.saveProfile();
          });
      },
    );
  }

}