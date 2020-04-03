import 'package:bebro/config/maps.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/net_config.dart';
import 'package:bebro/list_repository/comment_repository.dart';
import 'package:bebro/list_repository/post_repository.dart';
import 'package:bebro/list_repository/user_repository.dart';
import 'package:bebro/model/comment.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/pages/post/comment_dialog.dart';
import 'package:bebro/pages/post/send_post_page.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/util/build_date.dart';
import 'package:bebro/util/special_text/special_textspan.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/widget/item_builder.dart';
import 'package:bebro/widget/list_Indicator.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
as extended;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../profile_page.dart';
import '../view_img_page.dart';

class PostDetailPage extends StatefulWidget{

  //0:正常的顶部，到评论区
  final int offset;
  final int postId;
  const PostDetailPage({Key key, this.offset, this.postId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostDetailPageState();
  }

}

class _PostDetailPageState extends State<PostDetailPage> with TickerProviderStateMixin{
  String textSend = '';
  var _future;
  Post _post;
  TabController _tabController;
  PageController _pageController;
  ScrollController _scrollController= ScrollController();
  ScrollController _gridController= ScrollController();
  UserRepository _userRepository;
  PostRepository _postRepository;
  CommentRepository _commentRepository;
  @override
  void initState() {
    _future = _getPost();

    _tabController = TabController(length: 3, vsync: this,initialIndex: 1);
    _pageController = PageController(initialPage: 1);
    super.initState();
  }
  @override
  void dispose() {
    _userRepository?.dispose();
    _commentRepository?.dispose();
    _postRepository?.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  Future<void> _getPost() async {
      var res = await NetRequester.request(Apis.getPostByPostId(widget.postId));
      if(res['code']=='1' && res['data']!=null){
        _post =Post.fromJson(res['data']);
        _userRepository = UserRepository(_post.postId,3);
        _postRepository = PostRepository(_post.postId,4);
        _commentRepository = CommentRepository(_post.postId);
      }else{
        Toast.popToast('内容已经不在了');
        Future.delayed(Duration(milliseconds: 500), (){
          Navigator.pop(context);
        });
        throw '内容已经不在了';

      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context,snap){
          if (snap.connectionState == ConnectionState.done) {
            if (snap.hasError) {
              return Center(
                child: Text('加载失败，请重试',style: TextStyle(fontSize: ScreenUtil().setSp(48))),
              );
            }else{
              return Stack(
                children: <Widget>[
                  _buildBody(),
                  _buildInputBar()
                ],
              );
            }
          }else{
            return Center(
              child: SpinKitRing(
                lineWidth: 3,
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight =
        statusBarHeight + kToolbarHeight + 120.w;
    return extended.NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: _headerSliverBuilder,
        pinnedHeaderSliverHeightBuilder: () {
      return pinnedHeaderHeight;
    },
    body: PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        LoadingMoreList(
          ListConfig<User>(
            itemBuilder: (BuildContext context, User user, int index){
              return ItemBuilder.buildUserRow(context,user,3);
            },
            sourceList: _userRepository,
            indicatorBuilder: _buildIndicator,
            lastChildLayoutType: LastChildLayoutType.none,
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90))
          ),
        ),
        LoadingMoreList(
          ListConfig<Comment>(
            itemBuilder: (BuildContext context, Comment comment, int index){
              return ItemBuilder.buildComment(context,comment,_commentRepository,index);
            },
            sourceList: _commentRepository,
            indicatorBuilder: _buildIndicator,
              lastChildLayoutType: LastChildLayoutType.none,
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90))
          ),
        ),
        LoadingMoreList(
          ListConfig<Post>(
            itemBuilder: (BuildContext context, Post post, int index){
              return ItemBuilder.buildForwardRow(context,post);
            },
            sourceList: _postRepository,
            indicatorBuilder: _buildIndicator,
            lastChildLayoutType: LastChildLayoutType.none,
              padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(90))
          ),
        ),
      ],
    )
    );
  }
  List<Widget> _headerSliverBuilder(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        pinned: true,
        elevation: 0,
        title: Text('动态'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(-8),
          child: SizedBox(),
        ),
      ),
      _postInfo(),
      _content(),
      SliverToBoxAdapter(child: SizedBox(height: 20.w)),
      _tabBar()
    ];
  }

  Widget _tabBar() {
    return SliverToBoxAdapter(
      child: StickyHeader(
        header: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0))),
          elevation: 1,
          margin: EdgeInsets.all(0),
          child: Consumer<ThemeModel>(
              builder: (BuildContext context, themeModel, _) {
                return Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(300)),
                  child: TabBar(
                    onTap: (index) {
                      _pageController.jumpToPage(index);
                    },
                    controller: _tabController,
                    labelColor: Theme.of(context).accentColor,
                    unselectedLabelColor: themeModel.isDark?Colors.white:Colors.grey,
                    tabs: <Widget>[
                      Tab(text:'赞 ${_post.likeNum}'),
                      Tab(text:'评论 ${_post.commentNum}'),
                      Tab(text:'转发 ${_post.forwardNum}')
                    ],
                  ),
                );
              }
          ),
        ),
        content: SizedBox(height: 0),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _userRepository);
  }
  Widget _content() {
    return  SliverToBoxAdapter(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0))),
        elevation: 0,
        margin: EdgeInsets.all(0),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal:ScreenUtil().setWidth(42),
              vertical: ScreenUtil().setHeight(15)
          ),
          child: _buildContent(),
        ),

      ),
    );
  }
  _postInfo() {
    return SliverToBoxAdapter(
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(0))),
          margin: EdgeInsets.all(0),
          elevation: 0,
          child: MyListTile(
              top: 22,
              bottom: ScreenUtil().setWidth(20),
              left: 42,
              right: 24,
              useScreenUtil: false,
              leading: Container(
                width: ScreenUtil().setWidth(115),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => ProfilePage(userId:_post.userId)));
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(115),
                    child:  _post.avatarUrl==''|| _post.avatarUrl == null
                        ?Image.asset("images/flutter_logo.png")
                        :ClipOval(
                      child: ExtendedImage.network(_post.avatarUrl,cache: true),
                    ),
                  ),
                ),
              ),
              center: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_post.username,style: TextStyle(fontSize: ScreenUtil().setSp(52))),
                  Text(buildDate(_post.date),style: TextStyle(
                      fontSize: ScreenUtil().setSp(34),color: Colors.grey)),
                ],
              ),
            ),

      ),
    );
  }

  _buildContent() {
    if(_post.forwardId == null){
      var text =_post.text;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text ==''? Container(): _postText(text),
          SizedBox(height: ScreenUtil().setHeight(10)),
          _buildImage(),
        ],
      );
    }else{
      var text = _post.text;
      var index = text.indexOf('//@');
      if(_post.imageUrl!=''){
        switch(index){
          case -1:
            text =text+' ￥-${_post.imageUrl}-￥';
            break;
          case 0:
            text =' ￥-${_post.imageUrl}-￥'+text;
            break;
          default:
            text=text.substring(0,index-1)+' ￥-${_post.imageUrl}-￥'+text.substring(index,text.length);
        }
      }
      textSend = text;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text==''? Container(): _postText(text),
          SizedBox(height: ScreenUtil().setHeight(10),),
          Container(
              padding: EdgeInsets.symmetric(
                horizontal:ScreenUtil().setWidth(20),
                vertical: ScreenUtil().setHeight(5)),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
              ),
              child: _buildForward(),
            ),
        ],
      );
    }
  }

  _postText(String text) {
    return ExtendedText(text,
      style: TextStyle(fontSize: ScreenUtil().setSp(46)),
      specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
      onSpecialTextTap: (dynamic parameter) {
        String str =parameter.toString();
        print(str);
        if (parameter.startsWith("@")) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) =>
                  ProfilePage(username: str.substring(1,str.length),)));
        }else if(parameter.startsWith("￥-")){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  ViewImgPage(images: [str.substring(2,str.length-3)],
                    index: 0,postId: _post.postId.toString(),)));
        }
      },
    );
  }

  _buildImage() {
    var url;
    if(_post.forwardId != null){
      url = _post.forwardImageUrl ?? "";
    }else{
      url = _post.imageUrl ?? "";
    }
    List images = url.split('￥');
    if(images[0] == ''){
      return Container();
    }else if(images.length == 1){
      return  InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ViewImgPage(
                  images: images,index: 0,postId: _post.postId.toString())));
        },
        child: Hero(
                tag: _post.postId.toString()+images[0] +'0',
                child: Container(
                  /*constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(700),
                      maxWidth: ScreenUtil().setWidth(600)),*/
                  child: ExtendedImage.network(
                      NetConfig.ip+images[0],
                      cache: true,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black12,width: 0.5),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
                  ),
                )),
      );
    }else{
      return Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().setWidth(gridHeight[images.length])),
        child: GridView.count(
          padding: EdgeInsets.all(0),
          controller: _gridController,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 1.0,
          mainAxisSpacing: ScreenUtil().setWidth(12),
          crossAxisSpacing: ScreenUtil().setWidth(12),
          crossAxisCount: images.length < 3 ? 2 : 3,
          children: List.generate(images.length, (index) {
            return InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewImgPage(
                        images: images,index: index,postId: _post.postId.toString())));
              },
              child: Hero(
                tag: _post.postId.toString()+images[index] +index.toString(),
                child: ExtendedImage.network(
                  NetConfig.ip+images[index],
                  fit: BoxFit.cover,
                  shape: BoxShape.rectangle,
                  border: Border.all(color: Colors.black12,width: 1),
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
                  cache: true,
                ),
              ),
            );
          }),
        ),
      );
    }
  }

  _buildForward(){
    if(_post.forwardId!=null&&_post.forwardName==null){
      return Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Icon(Icons.error_outline),
            Text('哦豁，内容已不在了'),
          ],
        ),
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _postText('@'+_post.forwardName+' ：'+_post.forwardText??''),
          _buildImage(),
        ],
      );
    }
  }

  _buildInputBar() {
    return Positioned(
      bottom: 0,
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: Container(
          height:120.h,
          width: ScreenUtil().setWidth(1080),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FlatButton.icon(
                    onPressed: (){
                      showDialog(context: context,
                        builder: (context){
                        return CommentDialog(postId: _post.postId,list: _commentRepository);
                        }
                      );
                    },
                    textColor: Colors.grey,
                    icon: Icon(AntDesign.edit,color: Colors.grey,size: 15,),
                    label: Text('说点什么吧...                             ',
                         style: TextStyle(fontSize: ScreenUtil().setSp(40)))),
              ),
                  Container(
                    width: ScreenUtil().setWidth(160),
                    child: FlatButton(
                      child: Icon(_post.isLiked == 1?MyIcons.like_fill:MyIcons.like,
                          color: _post.isLiked == 1
                      ? Theme.of(context).primaryColor:Colors.grey),
                      onPressed: () async {
                        if(_post.isLiked == 0){
                          var res = await NetRequester.request(Apis.likePost(_post.postId));
                          if(res['code']=='1'){
                            setState(() {
                              _post.isLiked = 1;
                              _post.likeNum++;
                            });
                          }
                        }else{
                          var res = await NetRequester.request(Apis.cancelLikePost(_post.postId));
                          if(res['code']=='1'){
                            setState(() {
                              _post.isLiked = 0;
                              _post.likeNum--;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(160),
                    child: FlatButton(
                      child: Icon(MyIcons.retweet,color: Colors.grey),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                SendPostPage(type: 2,post: _post,text: textSend,)));
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}