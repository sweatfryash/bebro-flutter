

import 'package:bebro/CommonWidget/MyToast.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/utils/dio_provider.dart';
import 'package:dio/dio.dart';


class UserNet{
  static Dio _dio = MyDio.createDio();
  static Response _response;
  //获取验证码
  static Future<int> getEmail(String email) async {
    _response = await _dio.post("user/sendEmail", data: {"email": email});
   var JSESSIONID= _response.headers.value("set-cookie").substring(0,43);
   if (_dio.options.headers.containsKey('cookie')){
     _dio.options.headers['cookie']=JSESSIONID;
   }else{
     _dio.options.headers.addAll({'cookie':JSESSIONID});
   }
    return _response.data;
  }

  //登录
  static Future<Map<String, dynamic>> logIn(String email, String password) async {
    try {
      //404
      _response = await _dio.post("user/logIn",
          data: {"email": email, "password": password});
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        popToast(e.response.request.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        popToast(e.request.toString());
        popToast(e.message);
      }
    }

    if(_response.data=='') {
      Map<String,String> map = {};
      return map;
    }else
      return _response.data;
  }
  //注册用户
  static Future<int> insertUser(String email, String password, String code) async {
    _response = await _dio.post("user/insertUser",
        data: {
      'email': email, 'password': password, 'username': '新用户',
          'bio': '快写下个性签名吧', 'avatarUrl': 'http://112.74.169.4:8080/images/default.png',
          'code':code});
    return _response.data;
  }

//忘记密码
  static Future<int> updatePwd(String email, String password, String code) async {
    _response = await _dio.post("user/updatePwd",
        data: {"email": email, "password": password,'code':code});
    return _response.data;
  }
  //更新用户详细信息
  static Future<int> updateUserDetail(User user) async {
    _response = await _dio.post("user/updateUserDetail",
        data: {"email": user.email, "username": user.username,
              'avatarUrl':user.avatarUrl,'bio':user.bio
        });
    return _response.data;
  }
  //根据email获得user
  static Future<Map<String, dynamic>> findByEmail(String email) async {
    _response=await _dio.post("user/findByEmail",data: {"email":email});
    return _response.data;
  }
}





