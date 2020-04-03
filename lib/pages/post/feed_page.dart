import 'package:bebro/list_repository/post_repository.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/widget/list_Indicator.dart';
import 'package:bebro/widget/my_appbar.dart';
import 'package:bebro/widget/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> with AutomaticKeepAliveClientMixin{
  PostRepository _postRepository;
  @override
  void initState() {
    super.initState();
    _postRepository =  PostRepository(Global.profile.user.userId,2);
  }

  @override
  void dispose() {
    _postRepository?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.build(context,Text('关注')),
      body: RefreshIndicator(
        onRefresh: _postRepository.refresh,
        child: LoadingMoreList(
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
      ),
    );
  }
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _postRepository);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
