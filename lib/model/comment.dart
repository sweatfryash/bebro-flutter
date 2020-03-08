class Comment {
  int commentId;
  int userId;
  int postId;
  Null replyComId;
  int likeNum;
  Null date;
  int isLiked;
  Null content;

  Comment(
      {this.commentId,
        this.userId,
        this.postId,
        this.replyComId,
        this.likeNum,
        this.date,
        this.isLiked,
        this.content});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    userId = json['userId'];
    postId = json['postId'];
    replyComId = json['replyComId'];
    likeNum = json['likeNum'];
    date = json['date'];
    isLiked = json['isLiked'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['replyComId'] = this.replyComId;
    data['likeNum'] = this.likeNum;
    data['date'] = this.date;
    data['isLiked'] = this.isLiked;
    data['content'] = this.content;
    return data;
  }
}