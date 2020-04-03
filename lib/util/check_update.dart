import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:bebro/util/logger.dart';
import 'package:bebro/util/toast.dart';
import 'package:bebro/widget/update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';


class CheckoutUpdateUtil {

  //检查更新
  static checkUpdate(BuildContext context) async {
    var res = await NetRequester.request(Apis.checkUpdate());
    //Log().i(res);
    if (res ['code'] == '1') {
        String version = res['data']['version'];
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String localVersion = packageInfo.version;
        if (version != localVersion) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return UpdateDialog(res: res);
              });
        } else {
          Toast.popToast('当前已经是最新版本！');
          //Log().i('版本号相同');
        }

    }
  }

}