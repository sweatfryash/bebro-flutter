import 'package:bebro/model/comment.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:loading_more_list/loading_more_list.dart';

class CommentRepository extends LoadingMoreBase<Comment> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int postId;
  CommentRepository(this.postId);

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

    try {
      var result = await NetRequester.request(Apis.getCommentByPostId(postId, pageIndex));
      if(result.containsKey('data')){
        if (pageIndex == 1) {
          this.clear();
        }
        List source = result['data'] ?? [];
        source.forEach((item){
          var comment = Comment.fromJson(item);
          if (!this.contains(comment) && hasMore) this.add(comment);
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