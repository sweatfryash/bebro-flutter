import 'dart:io';

import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/util/logger.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/widget/LineProgress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatefulWidget{
  final Map res;

  const UpdateDialog({Key key, this.res}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UpdateDialogState();
  }

}

class _UpdateDialogState extends State<UpdateDialog> {
  String url;
  //更新内容，字符串描述
  String content ;
  String version ;
  double progress = 0.0;
  CancelToken cancelToken = CancelToken();
  String savePath;
  bool _downLoading = false;

  @override
  void initState() {
    url = Platform.isAndroid
        ? widget.res['data']['androidUrl']
        : widget.res['data']['iosUrl'];
    content = widget.res['data']['content'] ?? '';
    content = content.replaceAll('\\n', '\n');
    version = widget.res['data']['version'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 600.h,
            left: 108.w,
            child: Container(
              color: Colors.white,
              width: 863.w,
              height: 300.h,
            ),
          ),
          Positioned(
            left: ScreenUtil().setWidth(108),
            top: ScreenUtil().setHeight(440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/update_top_bg.png',
                    width: ScreenUtil().setWidth(863)),
                Container(
                  width: ScreenUtil().setWidth(863),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(57),
                      vertical: ScreenUtil().setHeight(36)),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft:
                        Radius.circular(ScreenUtil().setWidth(10)),
                        bottomRight:
                        Radius.circular(ScreenUtil().setWidth(10)),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("是否升级到$version版本",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,color: Colors.black)),
                      SizedBox(height: ScreenUtil().setHeight(52)),
                      Text(content, style:TextStyle(color: Colors.black)),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      Container(
                        height: ScreenUtil().setHeight(120),
                        child: _downLoading
                            ? LineProgress(
                          progress: progress,
                          color: Color(0xffe94339),
                          totalWidth: ScreenUtil().setWidth(749),
                        )
                            : FlatButton(
                          color: Color(0xffe94339),
                          colorBrightness: Brightness.dark,
                          child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(749),
                              child: Text("升级")),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(3.0)),
                          onPressed: () async {
                            setState(() {
                              _downLoading = true;
                            });
                            savePath = await _getSavePath(url);
                            _download(NetRequester.dio, url, savePath);
                            if (Platform.isAndroid) {
                            } else {
                              if (await canLaunch(url)) {
                                var res = await launch(url);
                                print("launch" + res.toString());
                              } else {
                                throw 'Could not launch $url';
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(114),
                  width: ScreenUtil().setWidth(1),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200)),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      cancelToken.cancel('cancel');
                    },
                    child: Image.asset(
                      "assets/images/update_app_close.png",
                      width: ScreenUtil().setWidth(87),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _download(Dio dio, String url, savePath) async {
    try {
      await dio.download(url, savePath,
          onReceiveProgress: showDownloadProgress, cancelToken: cancelToken);
    } on DioError catch (e)  {
      setState(() {
        _downLoading = false;
      });
      switch (e.type){
        case DioErrorType.CANCEL :
          Toast.popToast('下载已取消，可再次进入登录页面下载更新');
          break;
        case DioErrorType.CONNECT_TIMEOUT :
          Toast.popToast('下载连接超时');
          break;
        case DioErrorType.RECEIVE_TIMEOUT :
          Toast.popToast('接收数据超时');
          break;
        case DioErrorType.SEND_TIMEOUT :
          Toast.popToast('发送请求超时');
          break;
        case DioErrorType.RESPONSE :
          Toast.popToast('网络出错');
          break;
        case DioErrorType.DEFAULT :
          Toast.popToast('网络出错');
          break;
      }
      print(e);
    }

  }

  Future<void> showDownloadProgress(received, total) async {
    if (total != -1) {
      setState(() {
        progress = (received / total);
      });
    }else{
      Toast.popToast('下载失败啦');
      Navigator.pop(context);
    }
    if(received / total == 1){
      Navigator.pop(context);
      var openFileRes = await OpenFile.open(savePath);
      if(openFileRes.contains('denied')){
        Toast.popToast('请开启允许安装来自未知来源的软件选项');
        Future.delayed(Duration(seconds: 1), () async {
          openFileRes = await OpenFile.open(savePath);
        });
        //
      }
      Log().i(openFileRes);
    }
  }

  static Future<String> _getSavePath(url) async {
    final directory = await getExternalStorageDirectory();
    String path = directory.path;
    path = path+"/bebro"+url.substring(url.lastIndexOf('.'),url.length);
    return path;
  }
}