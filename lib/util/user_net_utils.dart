import 'package:bebro/model/user.dart';
import 'package:bebro/util/dio_provider.dart';
import 'package:bebro/util/toast.dart';
import 'package:dio/dio.dart';

class UserNet {
  static Dio _dio = MyDio.createDio();
  static Response _response;


//忘记密码
  static Future<int> updatePwd(
      String email, String password, String code) async {
    _response = await _dio.post("user/updatePwd",
        data: {"email": email, "password": password, 'code': code});
    return _response.data;
  }

  //更新用户详细信息
  static Future<int> updateUserDetail(User user) async {
    _response = await _dio.post("user/updateUserDetail", data: {
      "email": user.email,
      "username": user.username,
      'avatarUrl': user.avatarUrl,
      'bio': user.bio
    });
    return _response.data;
  }

}
