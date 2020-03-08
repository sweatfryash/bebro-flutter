import 'package:dio/dio.dart';

class MyDio {
  static Dio dio;

  static Dio createDio() {
    if (dio == null) {
      var options = BaseOptions(
        //baseUrl: "http://10.0.2.2:8080/",
        //baseUrl: "http://112.74.169.4:8080/bebro/",
        baseUrl: "http://192.168.1.109:8080/",
        contentType: Headers.formUrlEncodedContentType,
      );
      dio = new Dio(options);
    }
    return dio;
  }
}
