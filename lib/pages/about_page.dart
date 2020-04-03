
import 'package:bebro/util/check_update.dart';
import 'package:bebro/widget/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _AboutPageState();

}

class _AboutPageState extends State<AboutPage> {
  String localVersion ;
  PackageInfo packageInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.simpleAppbar('关于'),
      body: FutureBuilder(
        future: getPackageInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            localVersion = packageInfo.version;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    SizedBox(width: ScreenUtil().setWidth(1080),
                      height: ScreenUtil().setHeight(90),),
                    FlutterLogo(
                      size: ScreenUtil().setWidth(240),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Text('BeBro',style: TextStyle(fontFamily: 'chocolate',fontSize: ScreenUtil().setSp(100))),
                    Text(localVersion,style: TextStyle(color: Colors.grey)),
                  ],
                ),

                Column(
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(360),
                          vertical: ScreenUtil().setHeight(30)
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      color: Colors.white,
                      child: Text('检查更新',
                        style: TextStyle(
                            color:Theme.of(context).primaryColor,
                            fontSize: ScreenUtil().setSp(46)),),
                      onPressed: (){
                        CheckoutUpdateUtil.checkUpdate(context);
                      },
                    ),
                    SizedBox(height:50.h),
                    Text('develop by hch',style: TextStyle(fontSize: ScreenUtil().setSp(36),color: Colors.grey),),
                    SizedBox(height:40.h,)
                  ],
                ),
              ],
            );
          }else{
            return Container();
          }

        },
      ),
    );
  }

  getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}