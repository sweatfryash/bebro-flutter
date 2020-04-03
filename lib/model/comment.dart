import 'package:bebro/model/reply.dart';

class Comment {
  int commentId;
  int userId;
  String avatarUrl;
  String username;
  String date;
  String text;
  String imageUrl;
  int isLiked;
  int likeNum;
  int replyNum;
  List<Reply> replyList;

  Comment(
      {this.commentId,
        this.userId,
        this.avatarUrl,
        this.username,
        this.date,
        this.text,
        this.imageUrl,
        this.isLiked,
        this.likeNum,
        this.replyNum,
        this.replyList});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    userId = json['userId'];
    avatarUrl = json['avatarUrl'];
    username = json['username'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    isLiked = json['isLiked'];
    likeNum = json['likeNum'];
    replyNum = json['replyNum'];
    if (json['replyList'] != null) {
      replyList = new List<Reply>();
      json['replyList'].forEach((v) {
        replyList.add(new Reply.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['userId'] = this.userId;
    data['avatarUrl'] = this.avatarUrl;
    data['username'] = this.username;
    data['date'] = this.date;
    data['text'] = this.text;
    data['imageUrl'] = this.imageUrl;
    data['isLiked'] = this.isLiked;
    data['likeNum'] = this.likeNum;
    data['replyNum'] = this.replyNum;
    if (this.replyList != null) {
      data['replyList'] = this.replyList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}