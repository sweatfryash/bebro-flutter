import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/net_config.dart';
import 'package:bebro/list_repository/comment_repository.dart';
import 'package:bebro/list_repository/reply_repository.dart';
import 'package:bebro/model/comment.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/model/reply.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/pages/chat_page.dart';
import 'package:bebro/pages/post/comment_dialog.dart';
import 'package:bebro/pages/post/reply_page.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ItemBuilder {
  static Widget buildUserRow(BuildContext context, User user, int type) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: MyListTile(
          onTap: () {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ProfilePage(userId: user.userId)));
          },
          left: 40,
          leading: Container(
            height: ScreenUtil().setHeight(110),
            child: user.avatarUrl == '' || user.avatarUrl == null
                ? Image.asset("images/flutter_logo.png")
                : ClipOval(
              child: ExtendedImage.network(NetConfig.ip+'/images/'+user.avatarUrl, cache: true),
            ),
          ),
          center: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(user.username ?? '用户' + user.userId.toString(),
                  style: TextStyle(fontSize: ScreenUtil().setSp(48))),
              Row(
                children: <Widget>[
                  Text(user.followNum.toString() + '关注',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(34))),
                  SizedBox(width: ScreenUtil().setWidth(10)),
                  Text(user.fanNum.toString() + '粉丝',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(34))),
                ],
              ),
              user.bio == null || user.bio == ''
                  ? SizedBox(
                height: 0,
              )
                  : Text(user.bio,
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: ScreenUtil().setSp(34))),
            ],
          ),
          trailing: type == 1
              ? FollowButton(user: user)
              : type == 2
              ? IconButton(
            icon: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) =>
                      ChatPage(user: user,)));
            },
          )
              : Container()),
    );
  }

  static buildForwardRow(BuildContext context, Post post) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: MyListTile(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => ProfilePage(userId: post.userId)));
        },
        left: 40,
        leading: Container(
          height: ScreenUtil().setHeight(110),
          child: post.avatarUrl == '' || post.avatarUrl == null
              ? Image.asset("images/flutter_logo.png")
              : ClipOval(
            child: ExtendedImage.network(NetConfig.ip+'/images/'+post.avatarUrl, cache: true),
          ),
        ),
        center: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(post.username ?? '用户' + post.userId.toString(),
                style: TextStyle(fontSize: ScreenUtil().setSp(48))),
            Text(buildDate(post.date),
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenUtil().setSp(34))),
            ExtendedText(
              post.text,
              specialTextSpanBuilder:
              MySpecialTextSpanBuilder(context: context),
            )
          ],
        ),
      ),
    );
  }

  static buildComment(BuildContext context, Comment comment,
      CommentRepository list, int index) {
    String reply;
    if (comment.replyNum == 1) {
      reply = buildReply(comment.replyList[0], true);
    } else if (comment.replyList.length == 2) {
      reply = buildReply(comment.replyList[0], true)
          + '\n' + buildReply(comment.replyList[1], true);
    }
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: MyListTile(
        onTap: () {
          _showDialog(context,
              buildCommentDialogCard(context, comment, list, index),comment.userId);
        },
        left: 40,
        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(
                    builder: (context) => ProfilePage(userId: comment.userId)));
          },
          child: Container(
            height: ScreenUtil().setHeight(110),
            child: comment.avatarUrl == '' || comment.avatarUrl == null
                ? Image.asset("images/flutter_logo.png")
                : ClipOval(
              child: ExtendedImage.network(NetConfig.ip+'/images/'+comment.avatarUrl, cache: true),
            ),
          ),
        ),
        center: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(comment.username ?? '用户' + comment.userId.toString(),
                    style: TextStyle(fontSize: ScreenUtil().setSp(48))),
                SizedBox(width: ScreenUtil().setWidth(610),),
                Container(
                  height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setWidth(150),
                  child: FlatButton.icon(onPressed: () async {
                    var url = comment.isLiked == 1
                        ? Apis.cancelLikeComment(comment.commentId)
                        : Apis.likeComment(comment.commentId);
                    var res = await NetRequester.request(url);
                    if (res['code'] == '1') {
                      if (comment.isLiked == 1) {
                        comment.isLiked = 0;
                        comment.likeNum--;
                      } else {
                        comment.isLiked = 1;
                        comment.likeNum++;
                      }
                      list.setState();
                    }
                  },
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        comment.isLiked == 1 ? MyIcons.like_fill : MyIcons.like,
                        color: comment.isLiked == 1
                            ? Theme
                            .of(context)
                            .accentColor : Colors.grey,
                        size: ScreenUtil().setHeight(50),),
                      textColor: comment.isLiked == 1
                          ? Theme
                          .of(context)
                          .accentColor : Colors.grey,
                      label: Text(comment.likeNum.toString())
                  ),
                )
              ],
            ),
            Text(buildDate(comment.date),
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenUtil().setSp(34))),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ExtendedText(
              comment.text,
              style: TextStyle(fontSize: ScreenUtil().setSp(46)),
              specialTextSpanBuilder:
              MySpecialTextSpanBuilder(context: context),
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            comment.imageUrl != ''
                ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewImgPage(
                                  images: [comment.imageUrl],
                                  index: 0,
                                  postId: comment.commentId.toString())));
                },
                child: Hero(
                    tag: comment.commentId.toString() +
                        comment.imageUrl +
                        '0',
                    child: Container(
                        constraints: BoxConstraints(
                            maxHeight: ScreenUtil().setHeight(600),
                            maxWidth: ScreenUtil().setWidth(600)),
                        child: ExtendedImage.network(
                            NetConfig.ip + comment.imageUrl,
                            cache: true,
                            fit: BoxFit.cover,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.black12, width: 0.5),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(21))))))
                : SizedBox(height: 0),
            SizedBox(height: ScreenUtil().setHeight(10)),
            comment.replyNum > 0
                ? InkWell(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(
                        builder: (context) => ReplyPage(comment: comment,)));
              },
              child: Container(
                width: ScreenUtil().setWidth(820),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                    vertical: ScreenUtil().setHeight(10)),
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.06),
                    borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(21))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExtendedText(
                      reply,
                      specialTextSpanBuilder: MySpecialTextSpanBuilder(
                          context: context),
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(46)
                      ),
                    ),
                    comment.replyNum > 2
                        ? Container(
                      margin: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(15)),
                      child: Text(
                        '共${comment.replyNum}条回复',
                        style: TextStyle(color: Theme
                            .of(context)
                            .accentColor),
                      ),
                    )
                        : SizedBox(height: 0),
                  ],
                ),
              ),
            )
                : SizedBox(height: 0),
            Container(
              width: ScreenUtil().setWidth(800),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: Colors.grey[200])
              ),
            )
          ],
        ),
      ),
    );
  }

  static buildReplyRow(BuildContext context, Reply reply, ReplyRepository list,
      int index) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: MyListTile(
        onTap: () {
          _showDialog(context,
              buildReplyDialogCard(context,reply,list,index),reply.userId);
        },
        left: 40,
        leading: InkWell(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(
                    builder: (context) => ProfilePage(userId: reply.userId)));
          },
          child: Container(
            height: ScreenUtil().setHeight(110),
            child: reply.avatarUrl == '' || reply.avatarUrl == null
                ? Image.asset("images/flutter_logo.png")
                : ClipOval(
              child: ExtendedImage.network(reply.avatarUrl, cache: true),
            ),
          ),
        ),
        center: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(reply.username ?? '用户' + reply.userId.toString(),
                    style: TextStyle(fontSize: ScreenUtil().setSp(48))),
                SizedBox(width: ScreenUtil().setWidth(610),),
                Container(height: ScreenUtil().setHeight(60),
                  width: ScreenUtil().setWidth(150),
                  child: FlatButton.icon(onPressed: () async {
                    var url = reply.isLiked == 1
                        ? Apis.cancelLikeReply(reply.replyId)
                        : Apis.likeReply(reply.replyId);
                    var res = await NetRequester.request(url);
                    if (res['code'] == '1') {
                      if (reply.isLiked == 1) {
                        reply.isLiked = 0;
                        reply.likeNum--;
                      } else {
                        reply.isLiked = 1;
                        reply.likeNum++;
                      }
                      list.setState();
                    }
                  },
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        reply.isLiked == 1 ? MyIcons.like_fill : MyIcons.like,
                        color: reply.isLiked == 1
                            ? Theme
                            .of(context)
                            .accentColor : Colors.grey,
                        size: ScreenUtil().setHeight(50),),
                      textColor: reply.isLiked == 1
                          ? Theme
                          .of(context)
                          .accentColor : Colors.grey,
                      label: Text(reply.likeNum.toString())
                  ),
                )
              ],
            ),
            Text(buildDate(reply.date),
                style: TextStyle(
                    color: Colors.grey, fontSize: ScreenUtil().setSp(34))),
            SizedBox(height: ScreenUtil().setHeight(20)),
            ExtendedText(
              buildReply(reply, false),
              style: TextStyle(fontSize: ScreenUtil().setSp(46)),
              specialTextSpanBuilder:
              MySpecialTextSpanBuilder(context: context),
            ),
            SizedBox(height: ScreenUtil().setHeight(15)),
            reply.imageUrl != ''
                ? InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewImgPage(
                                  images: [reply.imageUrl],
                                  index: 0,
                                  postId: reply.commentId.toString())));
                },
                child: Hero(
                    tag: reply.commentId.toString() +
                        reply.imageUrl +
                        '0',
                    child: Container(
                        constraints: BoxConstraints(
                            maxHeight: ScreenUtil().setHeight(600),
                            maxWidth: ScreenUtil().setWidth(500)),
                        child: ExtendedImage.network(
                            NetConfig.ip + reply.imageUrl,
                            cache: true,
                            fit: BoxFit.cover,
                            shape: BoxShape.rectangle,
                            border: Border.all(
                                color: Colors.black12, width: 0.5),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(21))))))
                : SizedBox(height: 0),
            Container(
              width: ScreenUtil().setWidth(800),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.3, color: Colors.grey[200])
              ),
            )
          ],
        ),
      ),
    );
  }

  static String buildReply(Reply reply, bool showUsername) {
    var center = '';
    if (reply.beReplyName != '') {
      center = '回复@${reply.beReplyName} ';
    }
    if (showUsername) {
      return '@${reply.username} $center:${reply.text}';
    }
    return '$center${reply.text}';
  }

  static void _showDialog(BuildContext context, List<Widget> card,int userId) {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            child: Material(
              textStyle: TextStyle(fontSize: ScreenUtil().setSp(48),
                  color: Colors.black),
              color: Colors.black12,
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: ScreenUtil().setWidth(1080),
                      height: ScreenUtil().setHeight(1920),),
                  ),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),),
                      child: Container(
                        width: ScreenUtil().setWidth(740),
                        height: ScreenUtil().setHeight(
                            userId != Global.profile.user.userId ? 300 : 400),
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(60),
                            vertical: ScreenUtil().setHeight(40)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: card
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

  static buildCommentDialogCard(BuildContext context, Comment comment,
      LoadingMoreBase list, int index) {
    return <Widget>[
            MyListTile(
              onTap: () {
                Navigator.pop(context);
              },
              leading: Text('复制'),
            ),
            MyListTile(
              onTap: () {
                Navigator.pop(context);
                showDialog(context: context,
                    builder: (context) {
                      return CommentDialog(
                          commentId: comment.commentId, list: list);
                    }
                );
              },
              leading: Text('回复'),
            ),
            Offstage(
              offstage: comment.userId != Global.profile.user.userId,
              child: MyListTile(
                onTap: () async {
                  Navigator.pop(context);
                  var res = await NetRequester.request(
                      Apis.deleteComment(comment.commentId));
                  if (res['code'] == '1') {
                    list.removeAt(index);
                    list.setState();
                    Toast.popToast('已删除');
                  }
                },
                leading: Text('删除'),
              ),
            ),
          ];
  }

  static List<Widget> buildReplyDialogCard(BuildContext context, Reply reply,
      LoadingMoreBase list, int index) {
    return <Widget>[
      MyListTile(
        onTap: () {
          Navigator.pop(context);
        },
        leading: Text('复制'),
      ),
      MyListTile(
        onTap: () {
          Navigator.pop(context);
          showDialog(context: context,
              builder: (context) {
                return CommentDialog(
                    commentId: reply.commentId,beReplyName: reply.username,
                    list: list);
              }
          );
        },
        leading: Text('回复'),
      ),
      Offstage(
        offstage: reply.userId != Global.profile.user.userId,
        child: MyListTile(
          onTap: () async {
            Navigator.pop(context);
            var res = await NetRequester.request(
                Apis.deleteReply(reply.replyId));
            if (res['code'] == '1') {
              list.removeAt(index);
              list.setState();
              Toast.popToast('已删除');
            }
          },
          leading: Text('删除'),
        ),
      ),
    ];
  }
}
class FollowButton extends StatefulWidget {
  final User user;

  const FollowButton({Key key, this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _FollowButtonState();
  }
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      height: ScreenUtil().setHeight(70),
      child: OutlineButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        textColor: Theme.of(context).primaryColor,
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        padding: EdgeInsets.all(0),
        child: Text(
          widget.user.isFollow == 1 ? '相互关注' : '未关注',
          style: TextStyle(fontSize: ScreenUtil().setSp(36)),
        ),
        onPressed: () async {
          var fanId = Global.profile.user.userId;
          var res = await NetRequester.request(widget.user.isFollow == 0
              ? Apis.followAUser(fanId, widget.user.userId)
              : Apis.cancelFollowAUser(fanId, widget.user.userId));
          if (res['code'] == '1') {
            setState(() {
              widget.user.isFollow = widget.user.isFollow == 1 ? 0 : 1;
            });
            widget.user.isFollow == 1
                ? Global.profile.user.followNum++
                : Global.profile.user.followNum--;
            UserModel().notifyListeners();
          }
        },
      ),
    );
  }
}
