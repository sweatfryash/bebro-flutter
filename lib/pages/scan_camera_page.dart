import 'package:bebro/config/my_icon.dart';
import 'package:bebro/pages/profile_page.dart';
import 'package:bebro/pages/qr_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/util/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_scan/r_scan.dart';
import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

List<RScanCameraDescription> rScanCameras;

class RScanCameraDialog extends StatefulWidget {
  @override
  _RScanCameraDialogState createState() => _RScanCameraDialogState();
}

class _RScanCameraDialogState extends State<RScanCameraDialog>
    with TickerProviderStateMixin {
  Color backColor = Colors.black54;
  RScanCameraController _controller;
  bool isFirst = true;
  var previewH;
  var previewW;
  var previewRatio;
  var screenH;
  var screenW;
  var screenRatio;
  Animation _lineAnimation;
  AnimationController _lineController;

  @override
  void initState() {
    _lineController =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    _lineAnimation = Tween<double>(begin: 30, end: 600).animate(_lineController)
      ..addListener(() {
        if (_lineController.isCompleted) {
          _lineController.reset();
          _lineController.forward();
        }
        setState(() {});
      });
    _lineController.forward();
    if (rScanCameras != null && rScanCameras.length > 0) {
      _controller = RScanCameraController(
          rScanCameras[0], RScanCameraResolutionPreset.ultraHigh)
        ..addListener(() {
          final result = _controller.result;
          if (result != null) {
            if (isFirst) {
              _handleResult(result, context);
            }
          }
        })
        ..initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            var tmp = _controller.value.previewSize;
            previewH = max(tmp.height, tmp.width);
            previewW = min(tmp.height, tmp.width);
            previewRatio = previewH / previewW;
            //print(previewH);
          });
        });
    }
    screenH = ScreenUtil.screenHeight;
    screenW = ScreenUtil.screenWidth;
    screenRatio = screenH / screenW;
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _lineController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var border = BorderSide(width: 2.5, color: Theme.of(context).accentColor);
    if (rScanCameras == null || rScanCameras.length == 0) {
      return Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Text('相机不可用'),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Material(
      child: Stack(
        children: <Widget>[
          OverflowBox(
              maxHeight: ScreenUtil().setHeight(2232),
              maxWidth: ScreenUtil().setWidth(previewW * screenH / previewH),
              child: RScanCamera(_controller)),
          Column(
            children: <Widget>[
              Flexible(
                  child: AppBar(
                elevation: 0,
                title: Text('扫一扫'),
                backgroundColor: backColor,
                bottom: PreferredSize(
                  child: Container(),
                  preferredSize: Size.fromHeight(-8),
                ),
              )),
              Container(
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setHeight(260),
                decoration: BoxDecoration(
                    color: backColor,
                    border: Border(
                        top: BorderSide(color: backColor, width: 0.11),
                        bottom: BorderSide(color: backColor, width: 0.05))),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: ScreenUtil().setWidth(630),
                      decoration: BoxDecoration(
                          color: backColor,
                          border: Border.all(width: 0.04, color: backColor)),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                          width: ScreenUtil().setWidth(630),
                          height: ScreenUtil().setWidth(630),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).accentColor)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _buildContainer(context,
                                      Border(top: border, left: border)),
                                  _buildContainer(context,
                                      Border(top: border, right: border)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _buildContainer(context,
                                      Border(bottom: border, left: border)),
                                  _buildContainer(context,
                                      Border(bottom: border, right: border)),
                                ],
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(
                            top: ScreenUtil().setHeight(_lineAnimation.value),
                            left: ScreenUtil().setHeight(15),
                            right: ScreenUtil().setHeight(15)),
                        width: ScreenUtil().setWidth(600),
                        height: ScreenUtil().setWidth(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.01),
                                Theme.of(context).accentColor.withOpacity(0.8),
                                Theme.of(context).accentColor,
                                Theme.of(context).accentColor.withOpacity(0.8),
                                Theme.of(context)
                                    .accentColor
                                    .withOpacity(0.01),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      height: ScreenUtil().setWidth(630),
                      decoration: BoxDecoration(
                          color: backColor,
                          border: Border.all(width: 0.04, color: backColor)),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: backColor,
                    border: Border.all(width: 0.04, color: backColor)),
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setHeight(836),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(120)),
                    Text('将二维码图片对准取景框即可自动扫描',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(height: ScreenUtil().setHeight(360)),
                    Container(
                      width: ScreenUtil().setHeight(630),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _buildGridItem(MyIcons.qr_code, '我的二维码名片', () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => QrPage(
                                          user: Global.profile.user,
                                        )));
                          }),
                          _buildGridItem(MyIcons.image, '从相册读取', () async {
                            ImagePicker.pickImage(source: ImageSource.gallery)
                                .then((image) async {
                                  if(image !=null){
                                    RScanResult result=await RScan.scanImagePath(image.path);
                                    if (result != null) {
                                      if (isFirst) {
                                        _handleResult(result, context);
                                      }
                                    }
                                  }
                            });
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container _buildContainer(BuildContext context, Border border) {
    return Container(
      width: ScreenUtil().setHeight(50),
      height: ScreenUtil().setHeight(50),
      decoration: BoxDecoration(border: border),
    );
  }

  Future<bool> getFlashMode() async {
    bool isOpen = false;
    try {
      isOpen = await _controller.getFlashMode();
    } catch (_) {}
    return isOpen;
  }

  Widget _buildFlashBtn(BuildContext context, AsyncSnapshot<bool> snapshot) {
    return snapshot.hasData
        ? Padding(
            padding: EdgeInsets.only(
                bottom: 24 + MediaQuery.of(context).padding.bottom),
            child: IconButton(
                icon: Icon(snapshot.data ? Icons.flash_on : Icons.flash_off),
                color: Colors.white,
                iconSize: 46,
                onPressed: () {
                  if (snapshot.data) {
                    _controller.setFlashMode(false);
                  } else {
                    _controller.setFlashMode(true);
                  }
                  setState(() {});
                }),
          )
        : Container();
  }

  Widget _buildGridItem(IconData icon, String label, Function function) {
    return Container(
      width: ScreenUtil().setWidth(290),
      child: Column(
        children: <Widget>[
          FlatButton(
              padding:
                  EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(35)),
              shape: CircleBorder(),
              color: Colors.white38,
              onPressed: function,
              child: Icon(
                icon,
                color: Colors.white,
                size: ScreenUtil().setWidth(70),
              )),
          SizedBox(height: ScreenUtil().setHeight(15)),
          Text(
            label,
            style: TextStyle(
                color: Colors.white, fontSize: ScreenUtil().setSp(40)),
          )
        ],
      ),
    );
  }

  //处理扫描结果
  Future<void> _handleResult(RScanResult result, BuildContext context) async {
    isFirst = false;
    var data = result.message;
    print(data);
    if (data.contains('userId=')) {
      var list = data.split('=');
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => ProfilePage(userId:int.parse(list[1]))));
    } else {
      showDialog(
        context: context,
        builder: (context){
          return Material(
            color: Colors.black26,
            child: Container(
              width: ScreenUtil().setWidth(1080),
              height: ScreenUtil().setHeight(1920),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(48),
                        vertical: ScreenUtil().setHeight(30)),
                    constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(350)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top:Radius.circular(ScreenUtil().setWidth(21))),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(800),
                                child: Text(data)),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              child: Text('复制', style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                              onPressed: (){
                                Navigator.pop(context);
                                try{
                                  Clipboard.setData(ClipboardData(text:data));
                                  Toast.popToast('文本已复制到剪贴板');
                                }
                                catch(e){
                                }
                              },
                            ),
                            FlatButton(
                              child: Text('打开', style:
                              TextStyle(color: Theme.of(context).primaryColor)),
                              onPressed: () async {
                                if (await canLaunch(data)) {
                                  Navigator.pop(context);
                                await launch(data);
                                }else{
                                  Toast.popToast('打开失败');
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ).then((v){
        Future.delayed(Duration(seconds: 1), (){
          isFirst = true;
        });

      });
    }
  }
}
