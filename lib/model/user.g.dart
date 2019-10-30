// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['email'] as String,
    json['username'] as String,
    json['password'] as String,
    json['avatarUrl'] as String,
    json['bio'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
    };
