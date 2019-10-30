// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    json['messageId'] as String,
    json['username'] as String,
    json['avatarUrl'] as String,
    json['text'] as String,
    json['imageUrl'] as String,
    json['date'] as String,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'username': instance.username,
      'avatarUrl': instance.avatarUrl,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
      'date': instance.date,
    };
