import 'dart:async';

import 'package:bebro/widget/MyWidget.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/util/toast.dart';
import 'package:flutter/material.dart';

class ForgetRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgetRouteState();
}

class _ForgetRouteState extends State<ForgetRoute> {
  Timer _timer;
  int _countdownTime;

  @override
  void initState() {
    super.initState();
    _countdownTime = 30;
  }

  //输入框控制器
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  String email;
  String pwd;
  String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("重置密码")),
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
                        startCountdownTimer(); //点击后开始倒计时
                        Toast.popToast("验证码发送中，请稍等");
                        //请求发送验证码
                        email = _emailController.text;
                        var result = await NetRequester.request(Apis.sendEmail(email));
                        if (result == 1) {
                          Toast.popToast("验证码已发送请注意查收");
                        } else {
                          Toast.popToast("请检查网络或反馈错误 ");
                        }
                      }
                    },
                    child: Text(
                      _countdownTime == 30 ? '获取验证码' : '$_countdownTime秒后重新获取',
                      style: TextStyle(
                        color: _countdownTime == 30
                            ? Color.fromARGB(255, 17, 132, 255)
                            : Color.fromARGB(255, 183, 184, 195),
                      ),
                    ),
                  )),
            ), //验证码框
            Padding(
              //修改按钮
              padding:
                  const EdgeInsets.only(top: 70.0, left: 60.0, right: 40.0),
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text("确认修改"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  if ((_formKey.currentState as FormState).validate() &&
                      _emailController.text == email) {
                    pwd = _pwdController.text;
                    code = _codeController.text;
                    var result = await NetRequester.request(Apis.updatePassword(email, pwd, code));
                    //根据服务器返回结果进行提示
                    switch (result) {
                      case 1:
                        Toast.popToast("修改成功请前往登陆");
                        break;
                      case -1:
                        Toast.popToast("验证码错误");
                        break;
                      case 0:
                        Toast.popToast("该账户不存在请直接注册");
                        break;
                      case -2:
                        Toast.popToast("请先获取验证码");
                        break;
                    }
                  } else {
                    Toast.popToast("与获得验证码的邮箱不符");
                  }
                },
              ),
            ) //修改按钮
          ],
        ),
      ),
    );
  }

  void startCountdownTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_countdownTime == 0) {
        _timer.cancel();
        if(mounted){
          setState(() {
            _countdownTime = 30;
          });
        }
      }else{
        if(mounted){
          setState(() {
            _countdownTime--;
          });
        }
      }
    });
  } //倒计时实现方法

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  } //释放时取消定时器
}
