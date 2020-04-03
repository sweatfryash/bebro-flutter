import 'dart:typed_data';
import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/net_config.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/util/special_text/emoji_text.dart';
import 'package:bebro/util/special_text/special_textspan.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/util/upLoad_util.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class SendPostPage extends StatefulWidget {
  //1:发布动态 2：转发动态
  final int type;
  final Post post;
  final String text;
  const SendPostPage({Key key, this.type, this.post, this.text}) : super(key: key);
  @override
  _SendPostPageState createState() => new _SendPostPageState();
}

class _SendPostPageState extends State<SendPostPage> {

  List<Asset> images = List<Asset>();
  TextEditingController _textController = TextEditingController();
  double _keyboardHeight;
  bool _showEmoji;
  FocusNode _focusNode = FocusNode();
  int _maxImgNum;


  @override
  void initState() {
    _showEmoji = false;
    _maxImgNum = widget?.type==1 ? 9:1;
    if(widget.text!='' && widget.text!= null){
      _textController.text='//@${widget.post.username} :${widget.text}';
      _textController.selection = TextSelection.collapsed(offset: 0);
    }
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
      appBar: AppBar(
        elevation: 1,
        title: Text("发表动态"),
        actions: <Widget>[
          Consumer<UserModel>(builder: (BuildContext context, model, _) {
            return IconButton(
              icon: Icon(MyIcons.send),
              onPressed: () {
                _sendHandler(model);
              },
            );
          })
        ],
        bottom: PreferredSize(
            child: Container(), preferredSize: Size.fromHeight(-8)),
      ),
      body: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    //输入框
                    Container(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(33)),
                      height: ScreenUtil().setHeight(300),
                      child: ExtendedTextField(
                        specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
                        focusNode: _focusNode,
                        controller: _textController,
                        autofocus: true,
                        style: TextStyle(fontSize: ScreenUtil().setSp(46)),
                        keyboardType: TextInputType.multiline,
                        onEditingComplete: _changeRow,
                        maxLines: 5,
                        decoration: InputDecoration.collapsed(hintText: "分享当下的想法吧..."),
                      ),
                    ),
                    _buildSingleImg(),
                    //图片
                    widget.type ==2?_buildForwardPost():buildGridView(),
                  ],
                ),
              ),
              _inputBar(),
              emoticonPad(context),
            ],
          ),

    );
  }

  void _changeRow() {
    _textController.text += '\n';
  }
  Widget buildGridView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
      constraints: BoxConstraints(
        maxHeight: ScreenUtil().setWidth(_getHeight(images.length))
      ),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
        mainAxisSpacing: ScreenUtil().setWidth(18),
        crossAxisSpacing: ScreenUtil().setWidth(18),
        crossAxisCount: 3,
        children:
            List.generate(images.length < 9 ? images.length + 1 : 9, (index) {
          if (images.length < 9 && index == images.length) {
            return _buildAdd();
          } else {
            Asset asset = images[index];
            return Stack(
              children: <Widget>[
                AssetThumb(
                  asset: asset,
                  width: 300,
                  height: 300,
                ),
                deleteButton(index)
              ],
            );
          }
        }),
      ),
    );
  }
  Widget deleteButton(int index) => Positioned(
    right: 0.0,
    top: 0.0,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          images.removeAt(index);
        });
        print(images.length);
      },
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(4.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ScreenUtil().setWidth(10.0)),
          ),
          color: Colors.black54,
        ),
        child: Center(
          child: Icon(
            AntDesign.delete,
            size: ScreenUtil().setWidth(45.0),
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    final currentColorValue = '#${
        Theme.of(context).primaryColor.value.toRadixString(16).substring(2, 8)}';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: _maxImgNum,
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

  Widget _buildAdd() {
    return Container(
      color: Colors.black.withOpacity(0.05),
      width: ScreenUtil().setWidth(330),
      height: ScreenUtil().setWidth(330),
      child: InkWell(
        onTap: loadAssets,
        child: Icon(
          MyIcons.plus,
          size: ScreenUtil().setWidth(100),
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> _sendHandler(UserModel model) async {
    if(images.length==0 && _textController.text.length ==0 && widget.type ==1){
      Toast.popToast('请输入文字内容或选择图片');
      return;
    }
    if (images.length > 0) {
      Toast.popLoading('上传中...',20);
    }
    var flag = 1;
    String imageUrl='';
    for (var asset in images) {
      var name = asset.name;
      var type = name.substring(name.lastIndexOf('.', name.length));
      String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
      var filename = model.user.userId.toString() + timeStamp + type;
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      try{
        var res = await UpLoad.upLoad(imageData, filename);
        if (res == 0) {
          Toast.popToast('上传失败请重试');
          flag = 0;
        } else {
          imageUrl += "/images/$filename￥";
        }
      }catch(e){
        flag = 0;
        print(e.toString());
      }
    }
    if(flag == 1){
      var now = DateTime.now();
      var result;
      int forwardId;
      if(widget.type==1){
        forwardId=null;
      }else {
        forwardId=widget.post.forwardId ??widget.post.postId;
      }
      String text = _textController.text;
      if(widget.type ==2 && _textController.text==''){
        text= '转发动态';
      }
      if(widget.type ==2
          &&_textController.text=='//@${widget.post.username} :${widget.post.text}'){
        text= '转发动态'+text;
      }
      if(images.length!=0){
        imageUrl=imageUrl.substring(0,imageUrl.length-1);
      }
        var map ={
          'userId':model.user.userId,
          'text': text,
          'imageUrl':imageUrl,
          'date':now.toString().substring(0,19),
        'forwardId':forwardId
        };

        result = await NetRequester.request('/post/addPost',data: map);
      if(result['code'] =='1'){
        Toast.popToast('发布成功');
        Navigator.pop(context);
        model.user.postNum++;
        model.notifyListeners();
      }else{
        Toast.popToast('发布失败，请检查网络重试');
      }
      }
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
                              Future.delayed(Duration(milliseconds: 50), (){
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
                  Offstage(
                    offstage: !_showEmoji,
                    child: Container(
                      width: ScreenUtil().setWidth(160),
                      child: FlatButton(
                        child: Icon(MaterialCommunityIcons.backspace,
                            color: Theme.of(context).accentColor),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        onPressed: manualDelete,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  num _getHeight(int length) {
    if(length<3){
      return 365;
    }else if(length <6){
      return 705;
    }else{
      return 1040;
    }
  }

  void updateEmojiStatus() {
    final change = () {
      _showEmoji = !_showEmoji;
      if (mounted) setState(() {});
    };
    if (_showEmoji) {
      change();
    } else {
      //if (MediaQuery.of(context).viewInsets.bottom > 0.0) {
        SystemChannels.textInput.invokeMethod('TextInput.hide').whenComplete(
              () {Future.delayed(Duration(milliseconds: 40), (){
                change();
                });},);
      /*} else {
        change();
      }*/
    }
  }

  Widget emoticonPad(context) {
    return EmotionPad(
      active: _showEmoji,
      height: _keyboardHeight,
      controller: _textController,
    );
  }

  _buildForwardPost() {
    var url =widget.post.forwardId==null?widget.post.imageUrl:widget.post.forwardImageUrl;
    if(url== null){
      url='';
    }
    List images = url.split('￥');
    return Container(
      width: ScreenUtil().setWidth(1080),
      padding: EdgeInsets.all(ScreenUtil().setWidth(33)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(15),
        horizontal: ScreenUtil().setWidth(20)),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21))
        ),
        child: Row(
          children: <Widget>[
            images[0]==''
                ?SizedBox(width: 0)
                :ExtendedImage.network(NetConfig.ip+images[0],
              height: ScreenUtil().setHeight(120),
              width: ScreenUtil().setHeight(120),
              fit: BoxFit.cover,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21)),
            ),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.post.forwardId==null?'@'+widget.post.username:'@'+widget.post.forwardName,
                  style:TextStyle(fontSize: ScreenUtil().setSp(48))),
                Container(
                  width: ScreenUtil().setWidth(819),
                  child: ExtendedText(
                    widget.post.forwardId==null
                        ? widget.post.text
                    :widget.post.forwardText,
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(38)),
                    specialTextSpanBuilder: MySpecialTextSpanBuilder(context: context),
                    overFlowTextSpan: OverFlowTextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "...",)
                    ]),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildSingleImg() {
    return widget.type ==2 && images.isNotEmpty?Stack(
      children: <Widget>[
        Container(
          child: AssetThumb(
            asset: images[0],
            width: 50,
            height: 50,
          ),
        ),
        deleteButton(0)
      ],
    ):SizedBox(height: 0);
  }
  void manualDelete() {
    //delete by code
    final _value = _textController.value;
    final selection = _value.selection;
    if (!selection.isValid) return;

    TextEditingValue value;
    final actualText = _value.text;
    if (selection.isCollapsed && selection.start == 0) return;
    final int start =
    selection.isCollapsed ? selection.start - 1 : selection.start;
    final int end = selection.end;

    value = TextEditingValue(
      text: actualText.replaceRange(start, end, ""),
      selection: TextSelection.collapsed(offset: start),
    );
    MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
    MySpecialTextSpanBuilder(context: context);
    final oldTextSpan = _mySpecialTextSpanBuilder.build(_value.text);

    value = handleSpecialTextSpanDelete(value, _value, oldTextSpan, null);

    _textController.value = value;
  }
}
