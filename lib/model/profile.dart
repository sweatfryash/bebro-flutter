import 'package:bebro/model/user.dart';
class Profile {
  User user;
  List<String> searchList;
  int theme;
  bool isDark;
  String ip;

  Profile({this.user, this.searchList, this.theme, this.isDark, this.ip});
  Profile.none(this.searchList);
  Profile.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    searchList = json['searchList'].cast<String>();
    theme = json['theme'];
    isDark = json['isDark'];
    ip = json['ip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['searchList'] = this.searchList;
    data['theme'] = this.theme;
    data['isDark'] = this.isDark;
    data['ip'] = this.ip;
    return data;
  }
}
