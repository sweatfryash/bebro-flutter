import 'package:bebro/model/reply.dart';
import 'package:bebro/net/MyApi.dart';
import 'package:bebro/net/NetRequester.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ReplyRepository extends LoadingMoreBase<Reply> {
  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int commentId;

  ReplyRepository(this.commentId);

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
      var result = await NetRequester.request(Apis.getReplyByCommentId(commentId, pageIndex));
      if(result.containsKey('data')){
        if (pageIndex == 1) {
          this.clear();
        }
        List source = result['data'] ?? [];
        source.forEach((item){
          var reply = Reply.fromJson(item);
          if (!this.contains(reply) && hasMore) this.add(reply);
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