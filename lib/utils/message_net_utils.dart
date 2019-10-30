import 'package:bebro/model/message.dart';
import 'package:bebro/model/post.dart';
import 'package:bebro/model/postlist.dart';
import 'package:bebro/model/user.dart';
import 'package:bebro/utils/user_net_utils.dart';
import 'package:dio/dio.dart';
import 'dio_provider.dart';

class MessageNet{
  static Dio _dio = MyDio.createDio();
  static Response _response;

  //发布动态
  static Future<int> insertMessage(Message message) async {
    _response = await _dio.post("message/insertMessage",
        data: {
          'email': message.email, 'messageId': message.messageId, 'date': message.date,
          'text': message.text, 'imageUrl': message.imageUrl});
    return _response.data;
  }

  //获取所有动态
  static Future<List<Message>> getAllMessages() async{
    _response=await _dio.post("message/getAllMessages");
    List<Message> messageList=new List();
    for(var messageJson in _response.data){
        Message message=Message.fromJson(messageJson);
        if(message!=null) messageList.add(message);
    }
    return messageList;
  }

  //从服务器获取动态列表
  static Future<PostList> getPostList() async {
    List<Post> postItems= List();
    var messageList=await MessageNet.getAllMessages();
    for(var message in messageList){
      var userJson=await UserNet.findByEmail(message.email);
      User user =User.fromJson(userJson);
      Post post=new Post(message.messageId,user.username,user.avatarUrl,
          message.text,message.imageUrl,message.date);
      postItems.add(post);
    }
    print("这是在getPostList()函数中输出的:"+postItems.toString());
    PostList postList=PostList(postItems);
    return postList;
  }
}