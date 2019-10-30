import 'dart:io';
import 'package:bebro/CommonWidget/MyToast.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/utils/upLoad_util.dart';
import 'package:bebro/utils/user_net_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateUserDetailPage extends StatefulWidget{
  @override
  _UpdateUserDetailPageState createState() => _UpdateUserDetailPageState();
}
class _UpdateUserDetailPageState extends State<UpdateUserDetailPage>{
  final TextEditingController _usernameController= new TextEditingController();
  final TextEditingController _bioController= new TextEditingController();
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
        title: Text('修改信息'),
        actions: <Widget>[
          Consumer<UserModel>(builder: (BuildContext context,userModel,_){
            return IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                var usernameTemp= userModel.user.username;
                var bioTemp= userModel.user.bio;
                if(_usernameController.text!='') userModel.user.username=_usernameController.text;
                if(_bioController.text!='') userModel.user.bio=_bioController.text;
                if(_image==null){
                  var result=await UserNet.updateUserDetail(userModel.user);
                  if(result==1) {
                    popToast("信息更新成功");
                  }else{
                    popToast("信息更新失败，请重试");
                    userModel.user.username=usernameTemp;
                    userModel.user.bio=bioTemp;
                  }
                }else{
                  var avatarTemp= userModel.user.avatarUrl;
                  //userModel.user.avatarUrl="http://10.0.2.2:8080/images/"+userModel.user.email+_image.path.split("/").last;
                  userModel.user.avatarUrl="http://112.74.169.4:8080/bebro/images/"+userModel.user.email+_image.path.split("/").last;
                  var result1=await UpLoad.upLoad(_image,userModel.user.email);
                  if(result1==1){
                    var result2=await UserNet.updateUserDetail(userModel.user);
                    if(result2==1){
                      popToast("信息更新成功");
                  }
                  }else {
                    popToast("信息更新失败，请重试");
                    userModel.user.username=usernameTemp;
                    userModel.user.bio=bioTemp;
                    userModel.user.avatarUrl=avatarTemp;
                  }
                }
              },
            );
          })
        ],
      ),
      body: Consumer<UserModel>(builder: (BuildContext context,userModel,_){
            return  ListView(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              children: <Widget>[
                SizedBox(height: 30.0,),
                Row(
                  children: <Widget>[
                    Text('头像',style: TextStyle(fontSize: 20.0)),
                    SizedBox(width: 155.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).accentColor,width: 2.0),
                        borderRadius: const BorderRadius.all(const Radius.circular(8)),
                      ),
                        width: 100,height: 100.0,
                      child: InkWell(
                        onTap:getImage,
                        child:_image==null
                            ?CachedNetworkImage(
                              imageUrl: userModel.user.avatarUrl,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,)
                            :Image.file(_image,fit: BoxFit.cover)
                      )
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Text('昵称：',style: TextStyle(fontSize: 15.0)),
                    SizedBox(width: 30.0,),
                    Container(
                      width: 220.0,
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: userModel.user.username,
                            border: InputBorder.none
                        ),
                      ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).accentColor),
                          borderRadius: const BorderRadius.all(const Radius.circular(8)),)
                    ),
                  ],
                ),
                SizedBox(height: 20.0,),
                Row(
                  children: <Widget>[
                  Text('个性签名：',style: TextStyle(fontSize: 15.0)),
                  Container(
                    width: 220.0,
                      decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).accentColor),
                      borderRadius: const BorderRadius.all(const Radius.circular(8)),
                      ),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      controller: _bioController,
                      decoration: InputDecoration.collapsed(hintText: userModel.user.bio),
                    ),
                  ),
                ],),
              ],
            );
          },
        ),
    );
  }
}