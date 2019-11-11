import 'package:bebro/model/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postlist.g.dart';

@JsonSerializable()
class PostList {
  List<Post> postItems;

  PostList.none();

  PostList(this.postItems);

  factory PostList.fromJson(Map<String, dynamic> json) =>
      _$PostListFromJson(json);

  Map<String, dynamic> toJson() => _$PostListToJson(this);
}
