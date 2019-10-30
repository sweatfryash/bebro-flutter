
import 'package:bebro/model/postlist.dart';
import 'package:bebro/utils/message_net_utils.dart';
import 'package:flutter/material.dart';
import 'package:bebro/state/global.dart';

class PostListChangeNotifier extends ChangeNotifier{

  @override
  void notifyListeners() {
    Global.savePostList();
    super.notifyListeners();
  }
}

class PostListModel extends PostListChangeNotifier{

  PostList get postList{
    return Global.postList==null ? MessageNet.getPostList(): Global.postList;
  }

  set postList(PostList postList){
    Global.postList=postList;
    notifyListeners();
  }
}