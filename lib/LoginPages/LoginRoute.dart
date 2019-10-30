import 'package:bebro/CommonWidget/MyToast.dart';
import 'package:bebro/CommonWidget/MyWidget.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/utils/user_net_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => new _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  String email;
  String pwd;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight + 20.0,
            ), //顶部填充
            Image(
              image: AssetImage("images/flutter_logo.png"),
              width: 50.0,
              height: 50.0,
            ), //logo
            SizedBox(height: 40.0),
            buildEmailTextField(_nameController), //账号输入框
            TextFormField(
              controller: _pwdController,
              obscureText: _isObscure,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "密码不能少于6位",
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _eyeColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                        _eyeColor = _isObscure
                            ? Colors.grey
                            : Theme.of(context).iconTheme.color;
                      });
                    },
                  )),
              //校验密码
              validator: (v) {
                return v.trim().length > 5 ? null : "密码不能少于6位";
              },
            ), //密码框
            SizedBox(
              height: 8.0,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
                textColor: Colors.blue,
                child: Text(
                  '忘记密码？',
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'forget_page');
                },
              ),
            ), //忘记密码
            Padding(
              padding:
                  const EdgeInsets.only(top: 35.0, left: 60.0, right: 40.0),
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text("登录"),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                onPressed: () async {
                  if ((_formKey.currentState as FormState).validate()) {
                    email = _nameController.text;
                    pwd = _pwdController.text;
                    var result = await UserNet.logIn(email, pwd);
                    //根据服务器返回结果进行提示
                    if (result.isEmpty)
                      popToast("账户或密码输入错误，请重试");
                    else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'home_page', (route) => route == null);
                      User user = User.fromJson(result);
                      // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
                      Provider.of<UserModel>(context, listen: true).user = user;
                    }
                  }
                },
              ),
            ), //登录按钮
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('没有账号？'),
                  GestureDetector(
                    child: Text(
                      '点击注册',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'register_page');
                    },
                  ),
                ],
              ),
            ), //注册跳转
          ],
        ),
      ),
    );
  }
}
