import 'package:bebro/pages/post/common_post_page.dart';
import 'package:bebro/widget/my_appbar.dart';
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
    _pageList..add(CommonPostPage(type: 6))..add(CommonPostPage(type: 5));
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    var _tabBar =  TabBar(
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        controller: _tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        tabs: <Widget>[
          Tab(text:'热门'),
          Tab(text:'最新'),
        ],
      );
    return Scaffold(
      appBar: MyAppbar.build(context,_tabBar),
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
