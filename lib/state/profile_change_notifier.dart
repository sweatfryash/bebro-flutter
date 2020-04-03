import 'package:bebro/model/profile.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/state/global.dart';
import 'package:flutter/material.dart';

class ProfileChangeNotifier with ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}

class UserModel extends ProfileChangeNotifier {
  User get user => _profile.user;

  // APP是否登录(如果有用户信息，则证明登录过)
  bool get isLogin => user != null;

  //用户信息发生变化，更新用户信息并通知依赖它的子孙Widgets更新
  //条件成员访问符（?.）
  //和 . 类似，但是左边的操作对象不能为 null，
  set user(User user) {
    _profile.user = user;
    notifyListeners();
  }
}

class ThemeModel extends ProfileChangeNotifier {
  bool get isDark {
    return _profile.isDark == null ? false : _profile.isDark;
  }

  set isDark(bool value) {
    _profile.isDark = value;
    notifyListeners();
  }

  // 获取当前主题，如果未设置主题，则默认使用蓝色主题
  ColorSwatch get theme {
    return Global.themes.firstWhere((e) => e.value == _profile.theme,
        orElse: () => Colors.blue);
  }

  // 主题改变后，通知其依赖项，新主题会立即生效
  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
