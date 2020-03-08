import 'package:bebro/pages/hot_subpage/hot_page1.dart';
import 'package:bebro/pages/hot_subpage/hot_page2.dart';
import 'package:bebro/pages/hot_subpage/hot_page3.dart';
import 'package:bebro/common_widget/my_appbar.dart';
import 'package:bebro/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotPageState();
  }
}

class _HotPageState extends State<HotPage> with TickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  List<Widget> _pageList = List(); //列表存放页面
  int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageList..add(HotPage1())..add(HotPage2())..add(HotPage3());
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var _tabBar = Container(
      width: ScreenUtil().setWidth(540),
      child: TabBar(
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setHeight(29)),
        labelStyle: textDisplayDq.copyWith(fontWeight: FontWeight.bold),
        tabs: <Widget>[
          Text(
            '热门',
            style: textDisplayDq.copyWith(
                fontSize: ScreenUtil().setSp(_currentIndex == 0 ? 48 : 44)),
          ),
          Text(
            '最新',
            style: textDisplayDq.copyWith(
                fontSize: ScreenUtil().setSp(_currentIndex == 1 ? 48 : 44)),
          ),
          Text(
            '随便看看',
            style: textDisplayDq.copyWith(
                fontSize: ScreenUtil().setSp(_currentIndex == 2 ? 48 : 44)),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: MyAppbar.build(_tabBar),
      body: PageView(
        controller: _pageController,
        children: _pageList,
        onPageChanged: (index) {
          _tabController.animateTo(index);
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
