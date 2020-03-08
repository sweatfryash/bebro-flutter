import 'package:bebro/config/my_icon.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class EditRoute extends StatefulWidget {
  @override
  _EditRouteState createState() => new _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  final TextEditingController _textController = new TextEditingController();
  List<Asset> images = List<Asset>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发表动态", style: textDisplayDq),
        actions: <Widget>[
          Consumer<UserModel>(builder: (BuildContext context, userModel, _) {
            return IconButton(
              icon: Icon(MyIcons.send),
              onPressed: () {

              },
            );
          })
        ],
        bottom: PreferredSize(
            child: Container(), preferredSize: Size.fromHeight(-8)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all( ScreenUtil().setWidth(33)),
            height: ScreenUtil().setHeight(300),
            child: TextField(
              controller: _textController,
              autofocus: true,
              style: textDisplayDq,
              keyboardType: TextInputType.multiline,
              onEditingComplete: _changeRow,
              maxLines: 5,
              decoration: InputDecoration.collapsed(hintText: "分享当下的想法吧..."),
            ),
          ),
          Flexible(child: buildGridView(),),
        ],
      ),
    );
  }

  void _changeRow(){
    _textController.text+='\n';
  }



      //var result = await UpLoad.upLoad(_image.path, userModel.user.email);
        //上传message
        /*message.imageUrl = "http://10.0.2.2:8080/images/" +
                          userModel.user.email +
                          _image.path.split("/").last;*/
        /*message.imageUrl =
                          "http://112.74.169.4:8080/bebro/images/" +
                              userModel.user.email +
                              _image.path.split("/").last;*/

        //拼装一个post存入本地

  Widget buildGridView() {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(33)),
      mainAxisSpacing:ScreenUtil().setWidth(18),
      crossAxisSpacing:ScreenUtil().setWidth(18),
      crossAxisCount: 3,
      children: List.generate(images.length <9 ? images.length +1 : 9, (index) {
        if(images.length < 9 && index == images.length){
          return _buildAdd();
        }else{
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "选取图片",
          allViewTitle: "所有图片",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
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
  Widget _buildAdd(){
    return Container(
        color: Colors.grey.shade200,
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
}
