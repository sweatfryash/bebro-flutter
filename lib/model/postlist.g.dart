// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostList _$PostListFromJson(Map<String, dynamic> json) {
  return PostList(
    (json['postItems'] as List)
        ?.map(
            (e) => e == null ? null : Post.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostListToJson(PostList instance) => <String, dynamic>{
      'postItems': instance.postItems,
    };
