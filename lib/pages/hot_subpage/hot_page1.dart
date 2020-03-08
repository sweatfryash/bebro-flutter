import 'package:flutter/material.dart';

class HotPage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HotPage1State();
  }
}

class _HotPage1State extends State<HotPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('热门动态'),
      ),
    );
  }
}
