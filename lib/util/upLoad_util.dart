import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'dio_provider.dart';

class UpLoad {
  static Dio _dio = MyDio.createDio();
  static Response _response;

  //上传图片
  static Future<int> upLoad(
      Uint8List fileData, String filename) async {
    FormData formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(fileData, filename: filename)});
    _response = await _dio.post("upLoad", data: formData,
        onSendProgress: (send, total) {
      print('${send / total * 100}% total ${total / 1024}k');
    });
    return _response.data;
  }
}
