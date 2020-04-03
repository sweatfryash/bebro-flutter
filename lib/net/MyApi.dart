import 'package:bebro/state/global.dart';

class Apis {
  /*
  * user相关
  * */
  //登录
  static String login(String email, String password) {
    return '/user/logIn?email=$email&password=$password';
  }
  //获取验证码
  static String sendEmail(String email) {
    return '/user/sendEmail?email=$email';
  }
  //注册
  static String addUser(String email, String password,String code) {
    return '/user/addUser?email=$email&password=$password&code=$code';
  }
  //忘记密码
  static String updatePassword(String email, String password,String code) {
    return '/user/updatePwd?email=$email&password=$password&code=$code';
  }
  //根据ID查询用户
  static String findUserById(int askId,int userId) {
    return '/user/findUserById?askId=$askId&userId=$userId';
  }
  static String findUserByName(int askId,String username) {
    return '//user/findUserByName?askId=$askId&username=$username';
  }
  //修改用户信息
  static String updateUserProperty(String property, value) {
    int userId = Global.profile.user.userId;
    return '/user/updateUserProperty?userId=$userId&property=$property&value=$value';
  }
  //查找粉丝
  static String findFan(int userId, int page) {
    return '/user/findFan?userId=$userId&page=$page';
  }
  //查找关注的人
  static String findFollow(int userId, int page) {
    return '/user/findFollow?userId=$userId&page=$page';
  }
  //关注一个用户
  static String followAUser(int fanId, int followedId) {
    return '/user/followAUser?fanId=$fanId&followedId=$followedId';
  }
  //关注一个用户
  static String cancelFollowAUser(int fanId, int followedId) {
    return '/user/cancelFollowAUser?fanId=$fanId&followedId=$followedId';
  }
  static String searchUser(int page,String key) {
    int userId = Global.profile.user.userId;
    return '/user/searchUser?page=$page&askId=$userId&key=$key';
  }
  /*
  * 动态相关
  * */
  //点赞
  static String likePost(int postId) {
    int userId = Global.profile.user.userId;
    return '/post/likePost?userId=$userId&postId=$postId';
  }
  //取消赞
  static String cancelLikePost(int postId) {
    int userId = Global.profile.user.userId;
    return '/post/cancelLikePost?userId=$userId&postId=$postId';
  }
  //收藏
  static String starPost(int postId) {
    int userId = Global.profile.user.userId;
    return '/post/starPost?userId=$userId&postId=$postId';
  }
  //取消收藏
  static String cancelStarPost(int postId) {
    int userId = Global.profile.user.userId;
    return '/post/cancelStarPost?userId=$userId&postId=$postId';
  }
  static String getPostsById(int userId,int page) {
    int askId = Global.profile.user.userId;
    return '/post/getPostsById?askId=$askId&userId=$userId&page=$page';
  }
  //关注的动态，包括自己的
  static String getFollowPosts(int userId,int page) {
    return '/post/getFollowPosts?userId=$userId&page=$page';
  }
  //
  static String getStarPosts(int userId,int page) {
    return '/post/getStarPosts?userId=$userId&page=$page';
  }
  //删除post
  static String deletePost(int postId) {
    return '/post/deletePost?postId=$postId';
  }
  //postId查找post
  static String getPostByPostId(int postId) {
    int userId = Global.profile.user.userId;
    return '/post/getPostByPostId?postId=$postId&userId=$userId';
  }
  //转发记录
  static String getForwardPost(int postId,int page) {
    return '/post/getForwardPost?postId=$postId&page=$page';
  } //转发记录
  static String getAllPostsByDate(int userId,int page) {
    return '/post/getAllPostsByDate?userId=$userId&page=$page';
  }
  static String getHotPost(int page) {
    int askId = Global.profile.user.userId;
    return '/post/getHotPost?askId=$askId&page=$page';
  }
  static String searchPost(String key,String orderBy,int page) {
    int askId = Global.profile.user.userId;
    return '/post/searchPost?askId=$askId&page=$page&key=$key&orderBy=$orderBy';
  }
  static String searchFollowPost(String key,int page) {
    int askId = Global.profile.user.userId;
    return '/post/searchFollowPost?askId=$askId&page=$page&key=$key';
  }
  static String getLikedUser(int postId,int page) {
    int userId = Global.profile.user.userId;
    return '/user/getLikedUser?userId=$userId&postId=$postId&page=$page';
  }
  /*
  * 评论
  * */
  static String getCommentByPostId(int postId,int page) {
    int userId = Global.profile.user.userId;
    return '/comment/getCommentByPostId?askId=$userId&postId=$postId&page=$page';
  }
  //点赞评论
  static String likeComment(int commentId) {
    int userId = Global.profile.user.userId;
    return '/comment/likeComment?userId=$userId&commentId=$commentId';
  }
  //取消赞评论
  static String cancelLikeComment(int commentId) {
    int userId = Global.profile.user.userId;
    return '/comment/cancelLikeComment?userId=$userId&commentId=$commentId';
  }
  //删除post
  static String deleteComment(int commentId) {
    return '/comment/deleteComment?commentId=$commentId';
  }
  /*
  * 回复
  * */
  static String likeReply(int replyId) {
    int userId = Global.profile.user.userId;
    return '/reply/likeReply?userId=$userId&replyId=$replyId';
  }
  //取消赞
  static String cancelLikeReply(int replyId) {
    int userId = Global.profile.user.userId;
    return '/reply/cancelLikeReply?userId=$userId&replyId=$replyId';
  }
  static String getReplyByCommentId(int commentId,int page) {
    int userId = Global.profile.user.userId;
    return '/reply/getReplyByCommentId?askId=$userId&commentId=$commentId&page=$page';
  }
  static String deleteReply(int replyId) {
    return '/reply/deleteReply?replyId=$replyId';
  }


  //检查更新
  static String checkUpdate() {
      return '/user/checkUpdate';
  }

}
