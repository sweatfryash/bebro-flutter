import 'package:dio/dio.dart';

class MyDio {
  static Dio dio;

  static Dio createDio() {
    if (dio == null) {
      var options = BaseOptions(
        baseUrl: "http://10.0.2.2:8080/",
        //baseUrl: "http://112.74.169.4:8080/bebro/",
        contentType: Headers.formUrlEncodedContentType,
      );
      dio = new Dio(options);
    }
    return dio;
  }
}
