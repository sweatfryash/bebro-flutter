
import 'package:bebro/list_repository/user_repository.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/state/global.dart';
import 'package:bebro/widget/item_builder.dart';
import 'package:bebro/widget/list_Indicator.dart';
import 'package:bebro/widget/my_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

class FansPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FansPageState();
  }
}

class _FansPageState extends State<FansPage> {

  UserRepository _userRepository;
  @override
  void initState() {
    super.initState();
    _userRepository =  UserRepository(Global.profile.user.userId,1);
  }

  @override
  void dispose() {
    _userRepository?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar.simpleAppbar('关注我的人'),
      body: LoadingMoreList(
        ListConfig<User>(
          itemBuilder: (BuildContext context, User user, int index){
            return ItemBuilder.buildUserRow(context,user,1);
          },
          sourceList: _userRepository,
          indicatorBuilder: _buildIndicator,
        ),
      ),
    );
  }
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    return buildIndicator(context, status, _userRepository);
  }
}