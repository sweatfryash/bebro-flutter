import 'dart:convert';

import 'package:bebro/model/postlist.dart';
import 'package:bebro/model/profile.dart';
import 'package:bebro/utils/message_net_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.pink,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile.none();
  static PostList postList = PostList.none();

  // 可选的主题列表
  static List<MaterialColor> get themes => _themes;

  static Future init() async {
    postList = await MessageNet.getPostList();

    _prefs = await SharedPreferences.getInstance();
    //初始化加载profile
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    //初始化加载postList
    var _postList = _prefs.getString("_postList");
    if (_postList != null) {
      try {
        postList = PostList.fromJson(jsonDecode(_postList));
      } catch (e) {
        print(e);
      }
    }
  }

  //保存配置信息包括登录的User和主题
  static void saveProfile() {
    _prefs.setString('profile', jsonEncode(profile.toJson()));
    print(jsonEncode(profile.toJson()));
  }

  //保存Post,动态列表
  static void savePostList() {
    _prefs.setString('postList', jsonEncode(postList.toJson()));
    print(jsonEncode(profile.toJson()));
  }
}
