import 'package:bebro/model/user.dart';

part 'profile.g.dart';

class Profile {
  User user;
  num theme;
  bool isDark;
  bool isSavePwd;
  String ip;

  Profile.none(this.ip);

  Profile(this.user, this.theme, this.isDark, this.isSavePwd, this.ip);

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  String toString() {
    return 'Profile{user: $user, theme: $theme, isDark: $isDark, isSavePwd: $isSavePwd, ip: $ip}';
  }
}
