import 'package:bebro/state/global.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeChangeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主题'),
      ),
      body: ListView(
        //显示主题色块
        children: Global.themes?.map<Widget>((e) {
          return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 14),
              child: Container(
                color: e,
                height: 40,
              ),
            ),
            onTap: () {
              //主题更新后，MaterialApp会重新build
              Provider.of<ThemeModel>(context,listen: false).theme = e;
            },
          );
        })?.toList(),
      ),
    );
  }
}
