import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String email;
  String username;
  String password;
  String avatarUrl; //头像地址
  String bio;

  User(this.email, this.username, this.password, this.avatarUrl,
      this.bio); //个性签名

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
