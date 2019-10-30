import 'dart:io';

import 'package:dio/dio.dart';
import 'dio_provider.dart';

class UpLoad{
  static Dio _dio = MyDio.createDio();
  static Response _response;

  //上传图片
  static Future<int> upLoad(File file,String email) async{
    var name=email+file.path.split("/").last;
    //var name=file.path.split("/").last;
    FormData formData=FormData.fromMap({
      "file":await MultipartFile.fromFile(file.path,filename: name)
    });
    _response=await _dio.post("upLoad",data: formData);
    return _response.data;
  }
}