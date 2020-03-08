import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListTile extends StatefulWidget {
  final double height;
  final double left;
  final double right;
  final double top;
  final double bottom;
  final double betweenLeadingAndCenter;
  final double betweenCenterAndTrailing;
  final Widget leading;
  final Widget center;
  final Widget trailing;
  final GestureTapCallback onTap;
  final GestureDoubleTapCallback onDoubleTap;
  final bool useScreenUtil;

  const MyListTile(
      {Key key,
      this.height = 170,
      this.left = 15,
      this.right = 40,
      this.top = 20,
      this.bottom = 20,
      this.leading,
      this.center,
      this.trailing,
      this.onTap,
      this.onDoubleTap,
      this.betweenLeadingAndCenter = 30,
      this.betweenCenterAndTrailing = 30,
      this.useScreenUtil = true})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyListTileState();
  }
}

class _MyListTileState extends State<MyListTile> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.useScreenUtil
            ? ScreenUtil().setHeight(widget.height)
            : widget.height,
        padding: EdgeInsets.only(
          top: widget.useScreenUtil
              ? ScreenUtil().setHeight(widget.top)
              : widget.top,
          bottom: widget.useScreenUtil
              ? ScreenUtil().setHeight(widget.bottom)
              : widget.bottom,
          left: ScreenUtil().setHeight(widget.left),
          right: ScreenUtil().setHeight(widget.right),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(child: widget.leading),
                SizedBox(
                  width: ScreenUtil().setWidth(widget.betweenLeadingAndCenter)),
                Container(child: widget.center),
              ],
            ),
            Container(child: widget.trailing),
          ],
        ),
      ),
    );
  }
}
