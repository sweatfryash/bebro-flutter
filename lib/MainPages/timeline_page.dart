import 'dart:ffi';

import 'package:bebro/CommonWidget/common_divider.dart';
import 'package:bebro/CommonWidget/label_icon.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/state/postList_change_notifier.dart';
import 'package:bebro/utils/message_net_utils.dart';
import 'package:bebro/utils/uidata.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';

class TimelineOnePage extends StatelessWidget {

  //column1
  Widget profileColumn(BuildContext context, Post post) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      CircleAvatar(
        backgroundImage: NetworkImage(post.avatarUrl),
      ),
      Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.username,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .apply(fontWeightDelta: 700),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  post.date.substring(0,16),
                  style: TextStyle(fontFamily: UIData.ralewayFont),
                )
              ],
            ),
          ))
    ],
  );

  //column last
  Widget actionColumn(Post post,BuildContext context) => FittedBox(
    fit: BoxFit.contain,
    child: ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        LabelIcon(
          label: /*"${post.likesCount}   "*/"0",
          icon: Icons.favorite_border,
          iconColor: Theme.of(context).accentColor,
        ),
        SizedBox(width: 40.0,),
        LabelIcon(
          label: /*"${post.commentsCount}     "*/"0",
          icon: Icons.chat_bubble_outline,
          iconColor: Theme.of(context).accentColor,
        ),
      ],
    ),
  );

  //post cards
  Widget postCard(BuildContext context, Post post) {
    return Card(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: profileColumn(context, post),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              post.text,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: UIData.ralewayFont),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          post.imageUrl != ""
              ? Image.network(
            post.imageUrl,
            fit: BoxFit.cover,
          )
              : Container(),
          post.imageUrl != "" ? Container() : CommonDivider(),
          actionColumn(post,context),
        ],
      ),
    );
  }

  //allposts dropdown


/*  Widget appBar() => SliverAppBar(
    backgroundColor: Colors.black,
    elevation: 2.0,
    forceElevated: true,
    pinned: true,
    floating: true,
  );*/

  Widget bodyList(List<Post> postItems) {
    return SliverList(
    delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: postCard(context, postItems[index]),
      );
    }, childCount: postItems.length),
  );
  }

  /*Widget bodySliverList(PostListModel postListModel) {
    return FutureBuilder<List<Post>>(
        stream: postListModel.postList.postItems,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? CustomScrollView(
                slivers: <Widget>[
                bodyList(snapshot.data),
            ],
          )
              : Center(child: CircularProgressIndicator());
        });
  }*/

  @override
  Widget build(BuildContext context) {

   return Consumer<PostListModel>(
     builder: (BuildContext context,postListModel,_){
       return Scaffold(
         body:LiquidPullToRefresh(
           showChildOpacityTransition: false,
           onRefresh: () async {
             postListModel.postList=await MessageNet.getPostList();
             },
             child: CustomScrollView(
                    slivers: <Widget>[bodyList(postListModel.postList.postItems)])
         ),
         floatingActionButton: FloatingActionButton(
           child: Icon(Icons.edit),
           onPressed: () async {
             Navigator.pushNamed(context, 'edit_msg_page');
            },
          ),
        );
     },
   );
  }
}