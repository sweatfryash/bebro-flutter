import 'package:bebro/state/global.dart';

class Apis {
  /*
  * user相关
  * */
  //登录
  static String login(String email, String password) {
    return '/user/logIn?email=$email&password=$password';
  }
  //获取验证码
  static String sendEmail(String email) {
    return '/user/sendEmail?email=$email';
  }
  //注册
  static String addUser(String email, String password,String code) {
    return '/user/addUser?email=$email&password=$password&code=$code';
  }
  //忘记密码
  static String updatePassword(String email, String password,String code) {
    return '/user/updatePwd?email=$email&password=$password&code=$code';
  }
  //根据ID查询用户
  static String findUserById(int askId,int userId) {
    return '/user/findUserById?askId=$askId&userId=$userId';
  }
  //修改用户信息
  static String updateUserProperty(String property, value) {
    int userId = Global.profile.user.userId;
    return '/user/updateUserProperty?userId=$userId&property=$property&value=$value';
  }

}
