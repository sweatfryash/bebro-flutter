import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineProgress extends StatefulWidget{

  final Color color;
  final double progress;
  final double totalWidth;
  const LineProgress({
    Key key,
    this.color,
    this.progress,
    this.totalWidth
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _LineProgressState();

}

class _LineProgressState extends State<LineProgress> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 10),
          color: widget.color,
          height: 3.5,
          width: (widget.totalWidth - ScreenUtil().setWidth(130)) * widget.progress,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(7)),
          width: ScreenUtil().setWidth(108),
            child: Text((widget.progress * 100).toStringAsFixed(0) + "%",style:TextStyle(color: widget.color),)
        ),
        Expanded(
          child: Container(
            color: Colors.grey.shade300,
            height: 2,
          ),
        ),
      ],
    );
  }
}