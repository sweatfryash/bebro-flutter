import 'package:flutter/material.dart';

TextFormField buildEmailTextField(TextEditingController a) {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    controller: a,
    decoration: InputDecoration(
        labelText: "账号", hintText: "请输入您的邮箱地址", icon: Icon(Icons.person)),
    //校验用户名
    // ignore: missing_return
    validator: (String value) {
      var emailReg = RegExp(
          r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
      if (!emailReg.hasMatch(value)) {
        return '请输入正确的邮箱地址';
      }
    },
  );
} //邮箱输入框

TextFormField buildPwdTextField(TextEditingController a) {
  return TextFormField(
    controller: a,
    decoration: InputDecoration(
      labelText: "密码",
      hintText: "登陆密码最短6位",
      icon: Icon(Icons.lock),
    ),
    obscureText: true,
    //校验密码
    validator: (v) => v.trim().length > 5 ? null : "登录密码不能小于6位",
  );
} //密码输入框
