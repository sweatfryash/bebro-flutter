
import 'package:bebro/model/user.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:loading_more_list/loading_more_list.dart';

class UserRepository extends LoadingMoreBase<User> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int id;
  //1:查粉丝2：查关注3:点赞记录
  int type;
  String key;
  UserRepository(this.id,this.type,[this.key]);

  @override
  bool get hasMore => _hasMore || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    bool isSuccess = false;
    String url;
    switch (type){
      case 1:
        url = Apis.findFan(id,pageIndex);
        break;
      case 2:
        url = Apis.findFollow(id,pageIndex);
        break;
      case 3:
        url = Apis.getLikedUser(id,pageIndex);
        break;
      case 4:
        url = Apis.searchUser(pageIndex,key);
        break;
    }
    try {
      var result = await NetRequester.request(url);
      if(result.containsKey('data')){
        if (pageIndex == 1) {
          this.clear();
        }
        List source = result['data'] ?? [];
        source.forEach((item){
          var user = User.fromJson(item);
          if (!this.contains(user) && hasMore) this.add(user);
        });
        _hasMore = pageIndex < result['totalPage'];
        pageIndex++;
        isSuccess = true;
      }
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack.toString());
    }
    return isSuccess;
  }
}