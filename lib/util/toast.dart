import 'package:bebro/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';

class Toast {
  ///提供一个弹出toast的方法在okToast的方法基础上设置了一些基本参数，使用时只需传入@param[msg]
  static popToast(String msg, [ToastPosition position = ToastPosition.bottom]) {
    //这里调用的是okToast库的方法
    showToast(msg,
        dismissOtherToast: true,
        backgroundColor: Colors.black54,
        textPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        position: position,
        textStyle: textDisplayDq);
  }

  //弹出一个转圈圈，
  static popLoading([String msg = '']) {
    showToastWidget(
      Material(
        color: Colors.black54,
        child: Container(
          width: ScreenUtil().setWidth(1080),
          height: ScreenUtil().setHeight(1920),
          child: Center(
              child: Container(
            width: ScreenUtil().setWidth(300),
            height: ScreenUtil().setWidth(300),
            decoration: BoxDecoration(
              color: Color(0xddffffff),
              borderRadius: BorderRadius.circular(ScreenUtil().setHeight(21)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(30)),
                  child: SpinKitRing(
                    color: Colors.blue,
                    lineWidth: 3,
                    size: ScreenUtil().setWidth(120),
                  ),
                ),
                Offstage(
                  offstage: msg == '',
                  child: Text(msg, style: textDisplayDq),
                )
              ],
            ),
          )),
        ),
      ),
      position: ToastPosition.center,
      duration: Duration(seconds: 10),
      handleTouch: true,
    );
  }
}
