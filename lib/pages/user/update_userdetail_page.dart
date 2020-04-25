
import 'package:bebro/config/net_config.dart';
import 'package:bebro/widget/my_list_tile.dart';
import 'package:bebro/config/maps.dart';
import 'package:bebro/config/theme.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/state/profile_change_notifier.dart';
import 'package:bebro/util/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../change_avatar_page.dart';

class UpdateUserDetailPage extends StatefulWidget {
  @override
  _UpdateUserDetailPageState createState() => _UpdateUserDetailPageState();
}

class _UpdateUserDetailPageState extends State<UpdateUserDetailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('编辑资料'),
          bottom: PreferredSize(
            child: Container(),
            preferredSize: Size.fromHeight(-8),
          ),
        ),
        body: Consumer<UserModel>(
          builder: (BuildContext context, model, _) {
            return Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                MyListTile(
                  left: 40,
                  onTap: (){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => ChangeAvatarPage(
                        type: 1,)));
                  },
                  leading: Text('头像', style: TextStyle(
                          fontSize: ScreenUtil().setSp(44))),
                  trailing: Container(
                    height: 150.w,
                    width: 150.w,
                    child: CircleAvatar(
                      backgroundImage: model.user.avatarUrl == null
                          ?AssetImage("assets/images/flutter_logo.png")
                          :NetworkImage(NetConfig.ip+'/images/'+model.user.avatarUrl),
                    ),
                  ),
                ),
                MyListTile(
                  left: 40,
                  onTap: (){
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => ChangeAvatarPage(
                            type: 2)));
                  },
                  leading: Text('个人主页背景', style: TextStyle(
                          fontSize: ScreenUtil().setSp(44))),
                  trailing: Container(
                    width: 150.w,
                    height: 150.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(12)),
                        image: DecorationImage(
                          image: model.user.backImgUrl == null
                              ?AssetImage("assets/images/back.jpg")
                              :NetworkImage(NetConfig.ip+'/images/'+model.user.backImgUrl),
                          fit: BoxFit.cover
                        )
                      ),
                  ),
                ),
                MyListTile(
                  left: 40,
                  leading: Text('昵称'),
                  trailing: Text(model.user.username ?? '未设置'),
                  onTap: (){
                    showEditUsername(context,model);
                  },
                ),
                MyListTile(
                  left: 40,
                  leading: Text('性别'),
                  trailing: Text(gender[model.user.gender]),
                  onTap: (){
                    showPickerGender(context,model);
                  },
                ),
                MyListTile(
                  left: 40,
                  leading: Text('生日'),
                  trailing: Text(model.user.birthDay ?? '未设置'),
                  onTap: () {
                    showPickerDate(context,model);
                  },
                ),
                MyListTile(
                  left: 40,
                  leading: Text('城市'),
                  trailing: Text(model.user.city!=null
                      ?model.user.city.split('.')[1] : '未设置'),
                  onTap: (){
                    showPickerCity(context,model);
                  },
                ),
                MyListTile(
                  left: 40,
                  leading: Text('个性签名'),
                  trailing: Text(model.user.bio ?? ''),
                  onTap: (){
                    showEditBio(context,model);
                  },
                ),
              ],
            );
          },
        ),
    );
  }
  //性别
  showPickerGender(BuildContext context,UserModel model) {
    Picker(
        cancelText: '取消',
        confirmText: '确定',
        adapter: PickerDataAdapter<String>(
          pickerdata: ['女','男','未设置'],
        ),
        hideHeader: true,
        selecteds: [model.user.gender],
        selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor),
        textStyle: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(48)),
        onConfirm: (Picker picker, List value) async {
          print(value.first);
          var gender = value.first;
          var res = await NetRequester.request(Apis.updateUserProperty('gender', gender));
          if(res['code'] == '1'){
            model.user.gender = gender;
            model.notifyListeners();
          }
        }
    ).showDialog(context);
  }
  //城市
  showPickerCity(BuildContext context,UserModel model) {
    var code=['0','0'];
    if(model.user.city!=null){
      var cityCode =model.user.city.split('.').first;
      code= cityCode.split(',');
    }

    Picker(
        cancelText: '取消',
        confirmText: '确定',
        adapter: PickerDataAdapter<String>(
          pickerdata:cityData,
        ),
        hideHeader: true,
        selecteds: [int.parse(code[0]),int.parse(code[1])],
        selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor),
        textStyle: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(48)),
        onConfirm: (Picker picker, List value) async {
          List l=picker.getSelectedValues();
          var city = value[0].toString()+','+value[1].toString()+'.'+l[0]+' '+l[1];
          print(city);
          var res = await NetRequester.request(Apis.updateUserProperty('city', city));
          if(res['code'] == '1'){
            model.user.city =city;
            model.notifyListeners();
          }
        }
    ).showDialog(context);
  }
  //生日
  showPickerDate(BuildContext context,UserModel model) {
    var yearEnd=DateTime.now().year;
    /*var currentDate=model.user.birthDay.split('-');
    print(currentDate.toString());
    print(int.parse(currentDate[1]));*/
    Picker(
      cancelText: '取消',
        confirmText: '确定',
        hideHeader: true,
        selecteds: [0,0, 0],
        adapter: DateTimePickerAdapter(
          months: MonthsList_CN,
          yearEnd: yearEnd,
          customColumnType: [0,1,2]
        ),
        selectedTextStyle: TextStyle(color: Theme.of(context).primaryColor),
        textStyle: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(48)),
        onConfirm: (Picker picker, List value) async {
          String birthDay = (picker.adapter as DateTimePickerAdapter).value.toString();
          birthDay = birthDay.substring(0,10);
          var res = await NetRequester.request(Apis.updateUserProperty('birthDay', birthDay));
          if(res['code'] == '1'){
            model.user.birthDay = birthDay;
            model.notifyListeners();
          }
        }
    ).showDialog(context);
  }
  //签名
  showEditBio(BuildContext context,UserModel model){
    TextEditingController controller = TextEditingController();
    controller.text = model.user.bio ?? '';
    showDialog(context: context,
    builder: (context){
      return Material(
        color: Colors.black26,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: ScreenUtil().setWidth(1080),
            height: ScreenUtil().setHeight(1920),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(410)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(48),
                    vertical: ScreenUtil().setHeight(30)
                  ),
                  color: Colors.white,
                  child: TextField(
                    controller: controller,
                      style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                      maxLength: 60,
                      maxLengthEnforced: false,
                      autofocus: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        labelText: '修改个性签名',
                        border:OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(21)), //边角为30
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(20),
                          horizontal: ScreenUtil().setWidth(20)
                        ),
                      ),
                    ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FlatButton(
                        child: Text('取消', style:
                        TextStyle(color: Theme.of(context).primaryColor)),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('确定', style:
                        TextStyle(color: Theme.of(context).primaryColor)),
                        onPressed: () async {
                          if(controller.text.length > 60){
                            Toast.popToast('文字长度超出上限');
                          }else{
                            var bio =controller.text;
                            var map ={
                              'userId':model.user.userId,
                              'property': 'bio',
                              'value': bio
                            };
                            var result = await NetRequester.request('/user/updateUserProperty',data: map);
                            if(result['code'] == '1'){
                              model.user.bio = bio;
                              model.notifyListeners();
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    );
  }
  //昵称
  showEditUsername(BuildContext context,UserModel model){
    TextEditingController controller = TextEditingController();
    controller.text = model.user.username ?? '';
    showDialog(context: context,
        builder: (context){
          return Material(
            color: Colors.black26,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                width: ScreenUtil().setWidth(1080),
                height: ScreenUtil().setHeight(1920),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(410)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(48),
                          vertical: ScreenUtil().setHeight(30)
                      ),
                      color: Colors.white,
                      child: TextField(
                        controller: controller,
                        style: TextStyle(fontSize: ScreenUtil().setSp(42)),
                        maxLength: 15,
                        maxLengthEnforced: false,
                        autofocus: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          helperText: '若提示昵称已存在，请换一个尝试',
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: '修改昵称',
                          border:OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(ScreenUtil().setWidth(21)), //边角为30
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(20),
                              horizontal: ScreenUtil().setWidth(20)
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text('取消', style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text('确定', style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                            onPressed: () async {
                              if(controller.text.length > 15){
                                Toast.popToast('长度超出上限');
                              }else{
                                var username =controller.text;
                                var map1={'username':username};
                                var res = await NetRequester.request('/user/isExistTheUsername',data: map1);
                                if(res['code'] == '0'){
                                  var map2 ={'userId':model.user.userId,
                                    'property': 'username',
                                    'value': username};
                                  var result = await NetRequester.request('/user/updateUserProperty',data: map2);
                                  if(result['code'] == '1'){
                                    model.user.username = username;
                                    model.notifyListeners();
                                    Navigator.pop(context);
                                  }
                                }else{
                                  Toast.popToast('昵称已存在，请换一个尝试');
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
