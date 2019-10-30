// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message(
    json['messageId'] as String,
    json['email'] as String,
    json['date'] as String,
    json['text'] as String,
    json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'messageId': instance.messageId,
      'email': instance.email,
      'date': instance.date,
      'text': instance.text,
      'imageUrl': instance.imageUrl,
    };
