import 'package:bebro/model/post.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:loading_more_list/loading_more_list.dart';

class PostRepository extends LoadingMoreBase<Post> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int userId;
  //1:getPostsById 2:followPost
  int type;
  String key;
  String orderBy;
  PostRepository(this.userId,this.type,[this.key,this.orderBy]);

  @override
  bool get hasMore => _hasMore || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    //if(result){
      //Toast.popToast('刷新成功');
      /*final assetsAudioPlayer = AssetsAudioPlayer();
      assetsAudioPlayer.open(
        "assets/audio/refresh.mp3",
      );*/
    //}
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    String url;
    switch (type){
      case 1:
        url = Apis.getPostsById(userId,pageIndex);
        break;
      case 2:
        url = Apis.getFollowPosts(userId,pageIndex);
        break;
      case 3:
        url = Apis.getStarPosts(userId,pageIndex);
        break;
      case 4:
        url = Apis.getForwardPost(userId,pageIndex);
        break;
      case 5:
        url = Apis.getAllPostsByDate(userId,pageIndex);
        break;
      case 6:
        url = Apis.getHotPost(pageIndex);
        break;
      case 7:
        url = Apis.searchPost(key,orderBy,pageIndex);
        break;
      case 8:
        url = Apis.searchFollowPost(key,pageIndex);
        break;
    }
    bool isSuccess = false;
    try {
      Map result = await NetRequester.request(url);
      if(result.containsKey('data')){
        if (pageIndex == 1) {
          this.clear();
        }
        List source = result['data'];
        if(source.isNotEmpty){
          source.forEach((item){
            var post = Post.fromJson(item);
            if (!this.contains(post) && hasMore) this.add(post);
          });
        }
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