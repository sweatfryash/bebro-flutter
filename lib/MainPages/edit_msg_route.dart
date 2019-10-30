import 'dart:io';

import 'package:bebro/CommonWidget/MyToast.dart';
import 'package:bebro/model/message.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/state/postList_change_notifier.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/utils/message_net_utils.dart';
import 'package:bebro/utils/upLoad_util.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditRoute extends StatefulWidget {
  @override
  _EditRouteState createState() => new _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  final TextEditingController _textController= new TextEditingController();

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print(_image.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("发表动态"),
        actions: <Widget>[
          Consumer2<UserModel,PostListModel>(builder: (BuildContext context,userModel,postListModel,_){
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                var date=DateTime.now().toString()+"-0800";
                date=DateTime.parse(date).toString().substring(0,26);
                Message message=new Message.none();
                message.email=userModel.user.email;
                message.messageId=date+userModel.user.email;
                message.date=date;
                message.text=_textController.text;
                if(_image==null){
                  message.imageUrl=null;
                  uploadMessage(message);
                  Post post=Post(message.messageId,userModel.user.username,userModel.user.avatarUrl,
                  message.text,message.imageUrl,message.date);
                  postListModel.postList.postItems.add(post);
                }else{
                  var result=await UpLoad.upLoad(_image, userModel.user.email);
                  if(result==0){popToast("发表失败");}
                  else{
                    //上传message
                    //message.imageUrl="http://10.0.2.2:8080/images/"+userModel.user.email+_image.path.split("/").last;
                    message.imageUrl="http://112.74.169.4:8080/bebro/images/"+userModel.user.email+_image.path.split("/").last;
                    uploadMessage(message);
                    //拼装一个post存入本地
                    Post post=Post(message.messageId,userModel.user.username,userModel.user.avatarUrl,
                        message.text,message.imageUrl,message.date);
                    postListModel.postList.postItems.insert(0,post);
                  }
                }
              },
            );
          })
        ],
      ),
      body:Consumer<UserModel>(builder: (BuildContext context,userModel,_){
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[
            Container(
              width: 250.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(const Radius.circular(8)),
              ),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                controller: _textController,
                decoration: InputDecoration.collapsed(hintText: "分享当下的想法吧..."),
              ),
            ),
            Divider(height: 2,),
            Row(
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey,width: 2.0),
                      borderRadius: const BorderRadius.all(const Radius.circular(8)),
                    ),
                    width: 150,height: 150.0,
                    child: InkWell(
                        onTap:getImage,
                        child:_image==null
                            ? Icon(Icons.add,size: 60.0,)
                            :Image.file(_image,fit: BoxFit.cover)
                    )
                ),
              ],
            )
          ],
        );
    })
    );
  }
  Future<void> uploadMessage(Message message) async {
    var result=await MessageNet.insertMessage(message);
    if(result==0) {popToast("发表失败");}
    else{
      popToast("发表成功");
      Navigator.pop(context);
    }
  }
}
