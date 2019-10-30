import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void popToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIos: 3,
    backgroundColor: Colors.black54,
    textColor: Colors.white,
  );
}
