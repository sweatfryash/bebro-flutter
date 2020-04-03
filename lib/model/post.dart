
class Post {
  int postId;
  int userId;
  String username;
  String date;
  String text;
  String imageUrl;
  String avatarUrl;
  int likeNum;
  int commentNum;
  int forwardNum;
  int isLiked;
  int isStar;
  int forwardId;
  String forwardName;
  String forwardText;
  String forwardImageUrl;

  Post(
      {this.postId,
        this.userId,
        this.username,
        this.date,
        this.text,
        this.imageUrl,
        this.avatarUrl,
        this.likeNum,
        this.commentNum,
        this.forwardNum,
        this.isLiked,
        this.isStar,
        this.forwardId,
        this.forwardName,
        this.forwardText,
        this.forwardImageUrl});

  Post.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    userId = json['userId'];
    username = json['username'];
    date = json['date'];
    text = json['text'];
    imageUrl = json['imageUrl'];
    avatarUrl = json['avatarUrl'];
    likeNum = json['likeNum'];
    commentNum = json['commentNum'];
    forwardNum = json['forwardNum'];
    isLiked = json['isLiked'];
    isStar = json['isStar'];
    forwardId = json['forwardId'];
    forwardName = json['forwardName'];
    forwardText = json['forwardText'];
    forwardImageUrl = json['forwardImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['date'] = this.date;
    data['text'] = this.text;
    data['imageUrl'] = this.imageUrl;
    data['avatarUrl'] = this.avatarUrl;
    data['likeNum'] = this.likeNum;
    data['commentNum'] = this.commentNum;
    data['forwardNum'] = this.forwardNum;
    data['isLiked'] = this.isLiked;
    data['isStar'] = this.isStar;
    data['forwardId'] = this.forwardId;
    data['forwardName'] = this.forwardName;
    data['forwardText'] = this.forwardText;
    data['forwardImageUrl'] = this.forwardImageUrl;
    return data;
  }

  @override
  String toString() {
    return 'Post{postId: $postId, userId: $userId, username: $username, date: $date, text: $text, imageUrl: $imageUrl, avatarUrl: $avatarUrl, likeNum: $likeNum, commentNum: $commentNum, forwardNum: $forwardNum, isLiked: $isLiked, isStar: $isStar, forwardId: $forwardId, forwardName: $forwardName, forwardText: $forwardText, forwardImageUrl: $forwardImageUrl}';
  }

}