import 'package:bebro/config/my_icon.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/util/special_text/emoji_text.dart';
import 'package:bebro/util/special_text/special_textspan.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/util/upLoad_util.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CommentDialog extends StatefulWidget{

  final int postId;
  final int commentId;
  final String beReplyName;
  final LoadingMoreBase list;
  const CommentDialog({Key key, this.postId, this.commentId, this.list, this.beReplyName}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  TextEditingController _textController = TextEditingController();
  double _keyboardHeight;
  bool _showEmoji;
  FocusNode _focusNode = FocusNode();
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    _showEmoji = false;
    super.initState();
  }
  @override
  void dispose() {
    _textController?.dispose();
    _focusNode?.unfocus();
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight > 0) {
      _keyboardHeight = keyboardHeight;
      _showEmoji = false;
    }
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: (){
                  _focusNode?.unfocus();
                  Navigator.pop(context);
                },
              ),
            ),
            _buildTextFiled(),
            _inputBar(),
            emoticonPad(context)
          ],
        ),

    );
  }

  _inputBar() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        height: ScreenUtil().setHeight(110),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(160),
                  child: FlatButton(
                    child: Icon(_showEmoji?FontAwesome.keyboard_o:MyIcons.smile,
                      color: Color(0xff757575),),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    onPressed: (){
                      if (_showEmoji && _focusNode.canRequestFocus) {
                        updateEmojiStatus();
                        Future.delayed(Duration(milliseconds: 100), (){
                          SystemChannels.textInput.invokeMethod('TextInput.show');
                        });
                      }else{
                        updateEmojiStatus();
                      }
                    },
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(160),
                  child: FlatButton(
                    child: Icon(MyIcons.image,color: Color(0xff757575)),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    onPressed: loadAssets,
                  ),
                ),
                Container(
                  width: ScreenUtil().setWidth(160),
                  child: FlatButton(
                    child: Icon(MyIcons.at,color: Color(0xff757575)),
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    onPressed: (){},
                  ),
                ),
              ],
            ),
            Container(
              width: ScreenUtil().setWidth(170),
              child: FlatButton(
                child: Icon(MyIcons.send,color: Color(0xff757575)),
                padding: EdgeInsets.symmetric(horizontal: 0),
                onPressed: (){
                  _sendHandler();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _changeRow() {
    _textController.text += '\n';
  }

  void updateEmojiStatus() {
    final change = () {
      _showEmoji = !_showEmoji;
      if (mounted) setState(() {});
    };
    if (_showEmoji) {
      change();
    } else {
      if (MediaQuery.of(context).viewInsets.bottom != 0.0) {
        SystemChannels.textInput.invokeMethod('TextInput.hide').whenComplete(
              () {Future.delayed(Duration(milliseconds: 40), (){
            change();
          });},);
      } else {
        change();
      }
    }
  }
  Widget emoticonPad(context) {
    return EmotionPad(
      active: _showEmoji,
      height: _keyboardHeight,
      controller: _textController,
    );
  }

  _buildTextFiled() {
    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(
        topLeft: Radius.circular(ScreenUtil().setWidth(39)),
        topRight: Radius.circular(ScreenUtil().setWidth(39)),
      )),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(42),
            vertical: ScreenUtil().setHeight(15)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('发评论',style: TextStyle(color: Colors.grey)),
              Divider(color: Colors.grey),
              ExtendedTextField(
                specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
                focusNode: _focusNode,
                controller: _textController,
                autofocus: true,
                style: TextStyle(fontSize: ScreenUtil().setSp(46)),
                keyboardType: TextInputType.multiline,
                onEditingComplete: _changeRow,
                maxLines: 5,
                decoration: InputDecoration.collapsed(hintText: "说点什么吧..."),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              _buildImage(),
            ],
          ),

      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    final currentColorValue = '#${
        Theme.of(context).primaryColor.value.toRadixString(16).substring(2, 8)}';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          selectionFillColor: currentColorValue,
          takePhotoIcon: 'chat',
        ),
        materialOptions: MaterialOptions(
          statusBarColor: currentColorValue,
          actionBarColor: currentColorValue,
          actionBarTitle: "选取图片",
          allViewTitle: "所有图片",
          selectCircleStrokeColor: currentColorValue,
          selectionLimitReachedText: '已达到最大张数限制',
        ),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }

  _buildImage() {
    if(images.length!=0){
      return Container(
          constraints: BoxConstraints(
              maxHeight: ScreenUtil().setWidth(365)),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          mainAxisSpacing: ScreenUtil().setWidth(18),
          crossAxisSpacing: ScreenUtil().setWidth(18),
          crossAxisCount: 3,
          children: <Widget>[
            AssetThumb(
              asset: images.first,
              width: 300,
              height: 300,
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }

  Future<void> _sendHandler() async {
    if(_textController.text==''&& images.length==0){
      Toast.popToast('请输入文字或选择图片');
      return ;
    }
    String text = '';
    String imageUrl;
    if(images.length!=0){
      var asset =images.first;
      var name = asset.name;
      var type = name.substring(name.lastIndexOf('.', name.length));
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      var filename = Global.profile.user.userId.toString() + timeStamp + type;
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      try{
        var res = await UpLoad.upLoad(imageData, filename);
        if (res == 0) {
          Toast.popToast('上传失败请重试');
        } else {
          imageUrl = "/images/$filename";
        }
      }catch(e){
        print('错误'+e.toString());
      }
      if(_textController.text == ''){
        text = '图片评论';
      }else{
        text = _textController.text;
      }
    }else{
      text = _textController.text;
    }
    var now = DateTime.now();
    var url;
    var map;
    if(widget.postId!=null){
      map ={
        'userId':Global.profile.user.userId,
        'text': text,
        'imageUrl':imageUrl,
        'date':now.toString().substring(0,19),
        'postId':widget.postId
      };
      url='/comment/addComment';
    }else{
      map ={
        'userId':Global.profile.user.userId,
        'text': text,
        'date':now.toString().substring(0,19),
        'imageUrl':imageUrl,
        'beReplyName':widget.beReplyName,
        'commentId':widget.commentId
      };
      url='/reply/addReply';
    }
    var result = await NetRequester.request(url,data: map);
    if(result['code'] =='1'){
      Toast.popToast('发布成功');
      Navigator.pop(context);
      widget.list.refresh();
    }else{
      Toast.popToast('发布失败，请检查网络重试');
    }
  }
}