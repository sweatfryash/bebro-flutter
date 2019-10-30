import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            title: Text(
              '收到的赞',
              textScaleFactor: 1.2,
            ),
            leading: CircleAvatar(
              child: Icon(
                Icons.favorite_border,
                size: 35.0,
              ),
              maxRadius: 40.0,
            ),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text(
              '收到的评论',
              textScaleFactor: 1.2,
            ),
            leading: CircleAvatar(
              child: Icon(
                Icons.chat_bubble_outline,
                size: 35.0,
              ),
              maxRadius: 40.0,
            ),
            onTap: () {},
          ),
          Divider(),
        ],
      ),
    );
  }
}
