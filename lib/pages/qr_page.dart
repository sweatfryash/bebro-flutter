import 'dart:typed_data';
import 'dart:ui';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/pages/scan_camera_page.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/util/image_picker.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/widget/my_separator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:r_scan/r_scan.dart';

class QrPage extends StatelessWidget {
  final User user;
  QrPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    GlobalKey rootWidgetKey = GlobalKey();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('我的二维码名片'),
        bottom: PreferredSize(
            child: Container(), preferredSize: Size.fromHeight(-8)),
      ),
      body: Container(width:1080.w,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(),
            ),
                RepaintBoundary(
                  key: rootWidgetKey,
                  child: Container(
                    width: 840.w,
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil().setWidth(50),
                      vertical: 55.h
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(27))),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 150.h,
                              height: 150.h,
                              child: CircleAvatar(
                                backgroundImage: Global.profile.user.avatarUrl ==null
                                    ? AssetImage("assets/images/flutter_logo.png")
                                    : NetworkImage(Global.profile.user.avatarUrl),
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(40)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(user.username,
                                style: TextStyle(fontSize: ScreenUtil().setSp(52)),),
                                SizedBox(height: ScreenUtil().setHeight(20),),
                                Text('${user.followNum}关注 ${user.fanNum}粉丝',
                                style: TextStyle(fontSize: ScreenUtil().setSp(34),color: Colors.black87),)
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 55.h),
                        MySeparator(color: Colors.grey[300],),
                        SizedBox(height: 60.h),
                        QrImage(
                          data: "userId=${Global.profile.user.userId.toString()}",
                          version: 2,
                          size: 600.w,
                          embeddedImage: AssetImage("assets/images/flutter_logo.png"),
                        ),
                        Text('扫一扫，来BeBro砍我',style: TextStyle(color: Colors.black87,
                        fontSize: ScreenUtil().setSp(34)))
                      ],
                    ),
                  ),
                ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Container(
              width: ScreenUtil().setWidth(800),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildGridItem(MyIcons.save, '保存到相册', () async {
                    var res = await ImageSaver.save(await _capturePng(rootWidgetKey));
                    if(res.contains('.jpg')){
                      Toast.popToast('保存成功');
                    }else{
                      Toast.popToast('保存失败请重试');
                    }
                  }),
                  _buildGridItem(MyIcons.share, '分享二维码', () {}),
                  _buildGridItem(MyIcons.scan, '扫一扫', () async {
                    rScanCameras= await availableRScanCameras();
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => RScanCameraDialog()));})
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String label, Function function) {
    return Container(
      width: ScreenUtil().setWidth(210),
      child: Column(
        children: <Widget>[
          FlatButton(
              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(35)),
              shape: CircleBorder(),
              color: Colors.white38,
              onPressed: function,
              child: Icon(icon,
                  color: Colors.white,
              size: 70.h,)),
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

  Future<Uint8List> _capturePng(GlobalKey rootWidgetKey) async {
    try {
      RenderRepaintBoundary boundary =
      rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e);
    }
    return null;
  }

}
