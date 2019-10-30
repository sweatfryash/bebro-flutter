import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  String messageId;
  String username;
  String avatarUrl;
  String text;
  String imageUrl;
  String date;

  Post(this.messageId, this.username, this.avatarUrl, this.text, this.imageUrl,
      this.date);

  @override
  String toString() {
    return 'Post{messageId: $messageId, username: $username, avatarUrl: $avatarUrl, text: $text, imageUrl: $imageUrl, date: $date}';
  }


  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
/*int likesCount;
  int commentsCount;*/


}

