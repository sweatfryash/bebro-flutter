import 'package:bebro/config/net_config.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewImgPage extends StatefulWidget{
  final List images;
  final int index;
  final String postId;
  const ViewImgPage({Key key, this.images, this.index, this.postId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ViewImgPageState();
  }

}

class _ViewImgPageState extends State<ViewImgPage> {
  int currentIndex;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    currentIndex = widget.index;
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        return Future.value(true);
      },
      child: Material(
          color: Colors.black,
          child:Stack(
            children: <Widget>[
              ExtendedImageGesturePageView.builder(
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.images[index];
                  Widget image = ExtendedImage.network(
                    NetConfig.ip+item,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.gesture,
                  );
                  image = Container(
                    child: image,
                    padding: EdgeInsets.all(5.0),
                  );
                    return InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                          },
                          child: Hero(
                                tag: widget.postId +item + index?.toString(),
                                child: image,
                              ),
                        );
                },
                itemCount: widget.images.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                controller: PageController(
                  initialPage: currentIndex,
                ),
                scrollDirection: Axis.horizontal,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(60)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text((currentIndex+1).toString()+"/"+widget.images.length.toString(),
                      style: TextStyle(color: Colors.white),),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }


}