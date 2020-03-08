import 'package:bebro/model/comment.dart';

class Post {
  int postId;
  int userId;
  String date;
  String text;
  String imageUrl;
  Null avatarUrl;
  int likeNum;
  int isLiked;
  List<Comment> commentList;

  Post(
      {this.postId,
        this.userId,
        this.date,
        this.text,
        this.imageUrl,
        this.avatarUrl,
        this.likeNum,
        this.isLiked,
        this.commentList});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    userId = json['userId'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    avatarUrl = json['avatarUrl'];
    likeNum = json['likeNum'];
    isLiked = json['isLiked'];
    if (json['commentList'] != null) {
      commentList = new List<Comment>();
      json['commentList'].forEach((v) {
        commentList.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['userId'] = this.userId;
    data['date'] = this.date;
    data['text'] = this.text;
    data['imageUrl'] = this.imageUrl;
    data['avatarUrl'] = this.avatarUrl;
    data['likeNum'] = this.likeNum;
    data['isLiked'] = this.isLiked;
    if (this.commentList != null) {
      data['commentList'] = this.commentList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}