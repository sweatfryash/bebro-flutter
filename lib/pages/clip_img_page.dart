import 'dart:io';
import 'dart:typed_data';
import 'package:bebro/config/maps.dart';
import 'package:bebro/config/net_config.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/util/clip_editor_helper.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/util/upLoad_util.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClipImgPage extends StatefulWidget {
  final File image;
  final int type;
  ClipImgPage({Key key, this.image, this.type}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClipImgPageState();
}

class _ClipImgPageState extends State<ClipImgPage> {
  final GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('裁剪', style: textDisplayDq),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 9, horizontal: 10),
            width: ScreenUtil().setWidth(180),
            child: FlatButton(
              padding: EdgeInsets.all(0),
              child: Text(
                '完成',
                style: textDisplayDq.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: ScreenUtil().setSp(48)),
              ),
              color: Colors.white,
              onPressed: () {
                _upLoadImg();
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(-8),
        ),
      ),
      body: ExtendedImage.file(
        widget.image,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.editor,
        extendedImageEditorKey: editorKey,
        initEditorConfigHandler: (state) {
          return EditorConfig(
              eidtorMaskColorHandler:(context,pointerDown)=> Colors.black.withOpacity(pointerDown ? 0.4 : 0.8),
              lineColor: Colors.black.withOpacity(0.7),
              maxScale: 8.0,
              cropRectPadding: EdgeInsets.all(20.0),
              hitTestSize: 20.0,
              cropAspectRatio: CropAspectRatios.ratio1_1);
        },
      ),
    );
  }

  _upLoadImg() async {
    Toast.popLoading('上传中...');
    var path = widget.image.path.toString();
    var type = path.substring(path.lastIndexOf('.',path.length));
    String timeStamp=DateTime.now().millisecondsSinceEpoch.toString();
    var filename = Global.profile.user.userId.toString()+timeStamp+type;
    var fileData = await _clipImg();
    var res = await UpLoad.upLoad(fileData, filename);
    if (res == 0) {
      print('上传失败');
      Toast.popToast('上传失败请重试');
    } else {
      var remoteFilePath = "${NetConfig.ip}/images/$filename";
      var map ={
        'userId':Global.profile.user.userId,
        'property': widget.type ==1 ? 'avatarUrl' :'backImgUrl',
        'value': remoteFilePath
      };
      var result = await NetRequester.request('/user/updateUserProperty',data: map);
      if(result['code'] == '1'){
        Toast.popToast('上传成功');
        Navigator.pop(context);
        if( widget.type ==1){
          Global.profile.user.avatarUrl = remoteFilePath;
        }else{
          Global.profile.user.backImgUrl = remoteFilePath;
        }
        Global.saveProfile();
      }
    }
  }

  Future<Uint8List> _clipImg() async {
    Uint8List fileData;
    var msg = "";
    try {
      fileData =
          await cropImageDataWithNativeLibrary(state: editorKey.currentState);
      /*final filePath = await ImageSaver.save('cropped_image.jpg', fileData);
      msg = "图片保存路径 : $filePath";
      res = filePath;*/
    } catch (e, stack) {
      msg = "save faild: $e\n $stack";
    }
    print(msg);
    //showToast(msg);
    return fileData;
  }
}
