import 'package:bebro/config/maps.dart';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/net_config.dart';
import 'package:bebro/list_repository/post_repository.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/pages/post/post_detail_page.dart';
import 'package:bebro/pages/post/send_post_page.dart';
import 'package:bebro/pages/profile_page.dart';
import 'package:bebro/pages/view_img_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/util/build_date.dart';
import 'package:bebro/util/special_text/special_textspan.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PostCard extends StatefulWidget{
  final Post post;
  final PostRepository list;
  final int index;

  const PostCard({Key key, this.post, this.list, this.index}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PostCardState();
}


class _PostCardState extends State<PostCard>{
  String textSend = '';
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(24),
              vertical: ScreenUtil().setHeight(30)
          ),
          child: InkWell(
            onLongPress: (){
              _showDialog(context);
            },
            onTap: (){
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) =>
                      PostDetailPage(postId: widget.post.postId,offset: 0,)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _postInfo(),
                _buildContent(),
                _likeBar(context)
              ],
            ),
          ),
        ),
      );
  }
  _postInfo() {
    return MyListTile(
      top: 0,
      bottom: ScreenUtil().setWidth(20),
      left: 0,
      right: 0,
      useScreenUtil: false,
      leading: Container(
        width: ScreenUtil().setWidth(115),
        child: InkWell(
          onTap: (){
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => ProfilePage(userId:widget.post.userId)));
          },
          child: Container(
            height: ScreenUtil().setWidth(115),
            child:  widget.post.avatarUrl==''|| widget.post.avatarUrl == null
                ?Image.asset("images/flutter_logo.png")
                :ClipOval(
              child: ExtendedImage.network(NetConfig.ip+'/images/'+widget.post.avatarUrl,cache: true),
            ),
          ),
        ),
      ),
      center: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(widget.post.username,style: TextStyle(fontSize: ScreenUtil().setSp(52))),
          Text(buildDate(widget.post.date),style: TextStyle(
              fontSize: ScreenUtil().setSp(34),color: Colors.grey)),
        ],
      ),
      trailing: Container(
        width: ScreenUtil().setWidth(90),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          child:Icon(MyIcons.and_more,color: Colors.grey),
          onPressed: (){
            _showDialog(context);
          },
        ),
      ),
    );
  }

  _postText(String text) {
    return ExtendedText(text,
                style: TextStyle(fontSize: ScreenUtil().setSp(44)),
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
                                index: 0,postId: widget.post.postId.toString(),)));
                  }
                },
                maxLines: 6,
                overFlowTextSpan: OverFlowTextSpan(children: <TextSpan>[
                  TextSpan(
                    text: "...查看更多",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),)
                ]),
        );

  }

  _buildImage() {
    var url;
    if(widget.post.forwardId != null){
      url = widget.post.forwardImageUrl ?? "";
    }else{
      url = widget.post.imageUrl ?? "";
    }
    List images = url.split('￥');
    if(images[0] == ''){
      return Container();
    }else if(images.length == 1){
      return InkWell(
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ViewImgPage(
                  images: images,index: 0,postId: widget.post.postId.toString())));
        },
          child: Hero(
            tag: widget.post.postId.toString()+images[0] +'0',
              child: Container(
                constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(800),
                  maxWidth: ScreenUtil().setWidth(700)),
                child: ExtendedImage.network(
                    NetConfig.ip+images[0],
                    cache: true,
                    shape: BoxShape.rectangle,
                    border: Border.all(color: Colors.black12,width: 1),
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
                ),
              ))
      );
    }else{
      return Container(
        constraints: BoxConstraints(maxHeight: ScreenUtil().setWidth(gridHeight[images.length])),
        child: GridView.count(
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
                        images: images,index: index,postId: widget.post.postId.toString())));
              },
              child: Hero(
                  tag: widget.post.postId.toString()+images[index] +index.toString(),
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

  _buildContent() {
    if(widget.post.forwardId == null){
      var text =widget.post.text;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text ==''? Container(): _postText(text),
          SizedBox(height: ScreenUtil().setHeight(10),),
          _buildImage(),
        ],
      );
    }else{
      var text = widget.post.text;
      var index = text.indexOf('//@');
      if(widget.post.imageUrl!=''){
        switch(index){
          case -1:
            text =text+' ￥-${widget.post.imageUrl}-￥';
            break;
          case 0:
            text =' ￥-${widget.post.imageUrl}-￥'+text;
            break;
          default:
            text=text.substring(0,index-1)+' ￥-${widget.post.imageUrl}-￥'+text.substring(index,text.length);
        }
      }
      textSend= text;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text==''? Container(): _postText(text),
          SizedBox(height: ScreenUtil().setHeight(10),),
          InkWell(
            onTap: (){
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) =>
                      PostDetailPage(offset: 0,postId: widget.post.forwardId,)));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(20),
              vertical: ScreenUtil().setHeight(10)),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
              ),
              child: _buildForward(),
            ),
          ),
        ],
      );
    }
  }

  _likeBar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      height: ScreenUtil().setHeight(90),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              if(widget.post.isLiked == 0){
                var res = await NetRequester.request(Apis.likePost(widget.post.postId));
                if(res['code']=='1'){
                    setState(() {
                      widget.post.isLiked = 1;
                      widget.post.likeNum++;
                    });
                }
              }else{
                var res = await NetRequester.request(Apis.cancelLikePost(widget.post.postId));
                if(res['code']=='1'){
                    setState(() {
                      widget.post.isLiked = 0;
                      widget.post.likeNum--;
                    });
                }
              }
            },
            child: Row(
              children: <Widget>[
                Icon( widget.post.isLiked == 1?MyIcons.like_fill:MyIcons.like,
                    color: widget.post.isLiked == 1
                    ? Theme.of(context).accentColor:Colors.grey,
                    size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
                Text(widget.post.likeNum.toString(),
                    style: TextStyle(color: widget.post.isLiked == 1
                        ? Theme.of(context).accentColor:Colors.grey)),
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) =>
                      PostDetailPage(postId: widget.post.postId,offset: 1,)));
            },
            child: Row(
              children: <Widget>[
                Icon(MyIcons.comment,color: Colors.grey,size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
                Text(widget.post.commentNum.toString(),
                  style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) =>
                      SendPostPage(type: 2,post: widget.post,text: textSend,)));
            },
            child: Row(
              children: <Widget>[
                Icon(AntDesign.retweet,color: Colors.grey,size: ScreenUtil().setWidth(60)),
                SizedBox(width: ScreenUtil().setWidth(5)),
                Text(widget.post.forwardNum.toString(),
                  style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context){
          return Container(
            child: Material(
              textStyle: TextStyle(fontSize: ScreenUtil().setSp(48),color: Colors.black),
              color: Colors.black12,
              child:Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: ScreenUtil().setWidth(1080),
                      height: ScreenUtil().setHeight(1920),),
                  ),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
                      child: Container(
                        width: ScreenUtil().setWidth(740),
                        height: ScreenUtil().setHeight(widget.post.userId != Global.profile.user.userId?400 :500),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(60),
                            vertical: ScreenUtil().setHeight(40)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            MyListTile(
                              onTap: () async {
                                String url;
                                if(widget.post.isStar == 1){
                                  url = Apis.cancelStarPost(widget.post.postId);
                                }else{
                                  url = Apis.starPost(widget.post.postId);
                                }
                                var res = await NetRequester.request(url);
                                if(res['code']=='1'){
                                  Navigator.pop(context);
                                  Toast.popToast('已收藏');
                                    widget.post.isStar = widget.post.isStar == 1?0:1;
                                }
                              },
                              leading:Text(widget.post.isStar == 0?'收藏':'取消收藏'),
                            ),
                            MyListTile(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              leading:Text('复制'),
                            ),
                            MyListTile(
                              onTap: (){},
                              leading:Text('举报'),
                            ),
                            Offstage(
                              offstage: widget.post.userId != Global.profile.user.userId,
                              child: MyListTile(
                                onTap: _deletePost,
                                leading:Text('删除'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _deletePost() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))),
          title: Text('确定删除'),
          content: widget.post.text==''
              ?Container(height: ScreenUtil().setHeight(0),)
              :ExtendedText(widget.post.text,
            style: TextStyle(fontSize: ScreenUtil().setSp(44)),
            specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
            maxLines: 2,
            overFlowTextSpan: OverFlowTextSpan(children: <TextSpan>[
              TextSpan(
                text: "...",)
            ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('删除'),
              onPressed: () async {
                var res = await NetRequester.request(Apis.deletePost(widget.post.postId));
                if(res['code'] =='1'){
                  Toast.popToast('动态已删除');
                  widget.list.removeAt(widget.index);
                  widget.list.setState();
                  Global.profile.user.postNum--;
                  UserModel().notifyListeners();
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  _buildForward(){
    if(widget.post.forwardId!=null&&widget.post.forwardName==null){
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
          _postText('@'+widget.post.forwardName+' ：'+widget.post.forwardText??''),
          _buildImage(),
        ],
      );
    }

  }

}