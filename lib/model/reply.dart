class Reply {
  int replyId;
  int commentId;
  int userId;
  String avatarUrl;
  String username;
  String beReplyName;
  String date;
  String text;
  String imageUrl;
  int isLiked;
  int likeNum;

  Reply(
      {this.replyId,
        this.commentId,
        this.userId,
        this.avatarUrl,
        this.username,
        this.beReplyName,
        this.date,
        this.text,
        this.imageUrl,
        this.isLiked,
        this.likeNum});

  Reply.fromJson(Map<String, dynamic> json) {
    replyId = json['replyId'];
    commentId = json['commentId'];
    userId = json['userId'];
    avatarUrl = json['avatarUrl'];
    username = json['username'];
    beReplyName = json['beReplyName'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    isLiked = json['isLiked'];
    likeNum = json['likeNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['replyId'] = this.replyId;
    data['commentId'] = this.commentId;
    data['userId'] = this.userId;
    data['avatarUrl'] = this.avatarUrl;
    data['username'] = this.username;
    data['beReplyName'] = this.beReplyName;
    data['date'] = this.date;
    data['text'] = this.text;
    data['imageUrl'] = this.imageUrl;
    data['isLiked'] = this.isLiked;
    data['likeNum'] = this.likeNum;
    return data;
  }
}