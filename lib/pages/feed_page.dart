import 'package:bebro/common_widget/my_appbar.dart';
import 'package:bebro/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.build(Text(
        '关注',
        style: textDisplayDq,
      )),
    );
  }
}
