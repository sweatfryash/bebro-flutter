import 'dart:async';

import 'package:bebro/CommonWidget/MyToast.dart';
import 'package:bebro/CommonWidget/MyWidget.dart';
import 'package:bebro/utils/user_net_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterRoute extends StatefulWidget {
  @override
  _RegisterRouteState createState() => new _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  //计时变量
  Timer _timer;
  int _countdownTime = 0;

  //输入框控制器
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  String email;
  String pwd;
  String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("注册")),
      body: Form(
        key: _formKey, //设置globalKey,用于后面获取FormState

        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            SizedBox(
              height: 40.0,
            ),
            buildEmailTextField(_emailController), //邮箱输入框
            buildPwdTextField(_pwdController), //密码输入框
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _codeController,
              decoration: InputDecoration(
                  labelText: "验证码",
                  hintText: "点击右侧获取",
                  icon: Icon(Icons.security),
                  suffix: GestureDetector(
                    onTap: () async {
                      if (_countdownTime == 0 &&
                          (_formKey.currentState as FormState).validate()) {
                        setState(() {
                          _countdownTime = 60;
                        });
                        startCountdownTimer(); //点击后开始倒计时
                        popToast("验证码发送中，请稍等");
                        //请求发送验证码
                        email = _emailController.text;
                        //postCode()返回future必须用await
                        var result = await UserNet.getEmail(email);
                        if (result == 1) {
                          popToast("验证码已发送请注意查收");
                        } else {
                          popToast("请检查网络或反馈错误 ");
                        }
                      }
                    },
                    child: Text(
                      _countdownTime > 0 ? '$_countdownTime后重新获取' : '获取验证码',
                      style: TextStyle(
                        color: _countdownTime > 0
                            ? Color.fromARGB(255, 183, 184, 195)
                            : Color.fromARGB(255, 17, 132, 255),
                      ),
                    ),
                  )),
            ), //验证码框
            Padding(
              //注册按钮
              padding:
                  const EdgeInsets.only(top: 70.0, left: 60.0, right: 40.0),
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text("注册"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  if ((_formKey.currentState as FormState).validate() &&
                      _emailController.text == email) {
                    pwd = _pwdController.text;
                    code = _codeController.text;
                    var result = await UserNet.insertUser(email, pwd, code);
                    //根据服务器返回结果进行提示
                    switch (result) {
                      case 1:
                        popToast("注册成功请前往登陆");
                        break;
                      case -1:
                        popToast("验证码错误,尝试重新获取");
                        break;
                      case 0:
                        popToast("该邮箱已被注册");
                        break;
                      case -2:
                        popToast("请先获取验证码");
                    }
                  } else {
                    popToast("与获得验证码的邮箱不符");
                  }
                },
              ),
            ) //注册按钮
          ],
        ),
      ),
    );
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer.cancel();
            } else {
              _countdownTime = _countdownTime - 1;
            }
          })
        };

    _timer = Timer.periodic(oneSec, callback);
  } //倒计时实现方法

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  } //释放时取消定时器
}
