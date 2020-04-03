import 'dart:io';

import 'package:flutter/material.dart';

var myPrimaryColor = MaterialColor(4282096895, {
  50: Color(0xffe5f2ff),
  100: Color(0xffcce5ff),
  200: Color(0xff99cbff),
  300: Color(0xff66b2ff),
  400: Color(0xff3398ff),
  500: Color(0xff007eff),
  600: Color(0xff0065cc),
  700: Color(0xff004c99),
  800: Color(0xff003266),
  900: Color(0xff001933)
});
//大概的样式
final ThemeData myTheme = ThemeData(
  primarySwatch: MaterialColor(4282096895, {
    50: Color(0xffe5f2ff),
    100: Color(0xffcce5ff),
    200: Color(0xff99cbff),
    300: Color(0xff66b2ff),
    400: Color(0xff3398ff),
    500: Color(0xff007eff),
    600: Color(0xff0065cc),
    700: Color(0xff004c99),
    800: Color(0xff003266),
    900: Color(0xff001933)
  }),
  //整体为亮色主题
  brightness: Brightness.light,
  //主色
  primaryColor: Color(0xff3b9cff),
  primaryColorBrightness: Brightness.dark,
  primaryColorLight: Color(0xffcce5ff),
  primaryColorDark: Color(0xff004c99),
  accentColor: Color(0xff007eff),
  accentColorBrightness: Brightness.dark,
  canvasColor: Color(0xfffafafa),
  bottomAppBarColor: Color(0xffffffff),
  //分割线
  dividerColor: Color(0xffdadada),
  highlightColor: Color(0x66bcbcbc),
  splashColor: Color(0x66c8c8c8),
  unselectedWidgetColor: Color(0xfff3f3f3),
  disabledColor: Color(0x61000000),
  toggleableActiveColor: Color(0xff0065cc),
  secondaryHeaderColor: Color(0xffe5f2ff),
  textSelectionColor: Color(0xff99cbff),
  cursorColor: Color(0xff4285f4),
  backgroundColor: Color(0xff99cbff),
  dialogBackgroundColor: Color(0xffffffff),
  indicatorColor: Color(0xff007eff),
  hintColor: Color(0x8a000000),
  errorColor: Color(0xffd32f2f),
  //根据平台的不同使用不同的字体
  fontFamily: Platform.isIOS ? null : 'JetBrains Mono',
  platform: Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android,
);

//数字专用，没有设置大小
//框架并没有针对数字设置字体的功能，只能人为的去设定

