import 'package:bebro/config/my_icon.dart';
import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class ViewImgText extends SpecialText {
  static const String flag = "￥-";
  final int start;
  final Color color;

  ViewImgText(TextStyle textStyle,SpecialTextGestureTapCallback onTap ,
      {this.color, this.start})
      : super(flag, "-￥", textStyle,onTap: onTap);

  @override
  InlineSpan finishText() {

      return TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            child: Icon(MyIcons.image,color: color,size: 20,),
          ),
          TextSpan(text: '查看图片',
              style: TextStyle(color: color),
              recognizer: (TapGestureRecognizer()
                ..onTap = () {
                  if (onTap != null) onTap(toString());
                })
          ),
        ],

      );
    }

  }
