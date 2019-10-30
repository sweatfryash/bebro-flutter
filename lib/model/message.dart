import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()

class Message{

  String messageId;
  String email;
  String date;
  String text;
  String imageUrl;

  Message.none();
  Message(this.messageId, this.email, this.date, this.text, this.imageUrl);

  @override
  String toString() {
    return 'Message{messageId: $messageId, email: $email, date: $date, text: $text, imageUrl: $imageUrl}';
  }

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

