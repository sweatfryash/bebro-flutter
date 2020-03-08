import 'package:bebro/config/net_config.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/util/logger.dart';
import 'package:bebro/util/toast.dart';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';

class NetRequester {
  static var options = BaseOptions(
    baseUrl: Global.profile.ip ?? NetConfig.ip,
    contentType: Headers.formUrlEncodedContentType,
  );

  static Dio dio = Dio(options);
  static Response _response = Response();

  //再修改ip或端口后直接重设dio实例的baseUrl，不然请求的链接是不正确的，是旧的配置并没有更新
  static resetDio() {
    var newOptions = BaseOptions(
      baseUrl: Global.profile.ip ?? NetConfig.ip,
      contentType: Headers.formUrlEncodedContentType,
    );
    dio = Dio(newOptions);
    print(dio.options.headers);
  }

  /// 通用的网络请求方法，需传入@param[url]，
  /// @param[data]是可选参数，大部分[ApiAddress]返回的都是带参数的url，不需要[data]，提交审批结果那里是需要data的
  /// @param[file]也是可选参数，是上传图片的时候需要用到的
  static Future request(String url, {FormData file, Map data}) async {
    print('### url=$url');
    try {
      if (data != null) {
        _response = await dio.post(url, data: data);
      } else if (file != null) {
        _response = await dio.post(url, data: file);
      } else {
        _response = await dio.post(url);
      }
      //获取验证码的时候需要cookie
      if (url.contains("sendEmail")) {
        //print(_response.headers.toString());
        var sessionId = _response.headers.value("set-cookie").substring(0, 43);
        if (dio.options.headers.containsKey('cookie')) {
          dio.options.headers['cookie'] = sessionId;
        } else {
          dio.options.headers.addAll({'cookie': sessionId});
        }
      }
    } on DioError catch (e) {
      print('dioError:::::' + e.toString());
      switch (e.type) {
        case DioErrorType.CANCEL:
          Toast.popToast('请求已取消');
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          Toast.popToast('连接超时', ToastPosition.center);
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          Toast.popToast('接收数据超时', ToastPosition.center);
          break;
        case DioErrorType.SEND_TIMEOUT:
          Toast.popToast('发送请求超时', ToastPosition.center);
          break;
        case DioErrorType.RESPONSE:
          Toast.popToast('网络出错', ToastPosition.center);
          break;
        case DioErrorType.DEFAULT:
          Toast.popToast('网络出错', ToastPosition.center);
      }
    }
    Log().i('返回的数据：' + _response.data.toString());
    return _response.data;
  }
}
