import 'package:bebro/model/post.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/utils/message_net_utils.dart';
import 'package:bebro/utils/user_net_utils.dart';

class PostViewModel {
  List<Post> postItems;
  static List<Post> postList = new List();

  PostViewModel({this.postItems});

  getPosts() {
    print("更新成功，共有" + postList.length.toString() + "条动态");
    /*popToast("更新成功，共有"+postList.length.toString()+"条动态");*/
    return postList;
  }

  setPosts() async {
    var messageList = await MessageNet.getAllMessages();
    for (var message in messageList) {
      var userJson = await UserNet.findByEmail(message.email);
      User user = User.fromJson(userJson);
      Post post = new Post(message.messageId, user.username, user.avatarUrl,
          message.text, message.imageUrl, message.date);
      postList.add(post);
    }
  }
}
