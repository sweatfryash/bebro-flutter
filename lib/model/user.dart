
class User {
  int userId;
  String email;
  String username;
  String avatarUrl;
  String bio;
  String birthDay;
  int gender;
  String city;
  String backImgUrl;
  int postNum;
  int fanNum;
  int followNum;
  int isFollow;

  User(
      {this.userId,
        this.email,
        this.username,
        this.avatarUrl,
        this.bio,
        this.birthDay,
        this.gender,
        this.city,
        this.backImgUrl,
        this.postNum,
        this.fanNum,
        this.followNum,
        this.isFollow});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    email = json['email'];
    username = json['username'];
    avatarUrl = json['avatarUrl'];
    bio = json['bio'];
    birthDay = json['birthDay'];
    gender = json['gender'];
    city = json['city'];
    backImgUrl = json['backImgUrl'];
    postNum = json['postNum'];
    fanNum = json['fanNum'];
    followNum = json['followNum'];
    isFollow = json['isFollow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['username'] = this.username;
    data['avatarUrl'] = this.avatarUrl;
    data['bio'] = this.bio;
    data['birthDay'] = this.birthDay;
    data['gender'] = this.gender;
    data['city'] = this.city;
    data['backImgUrl'] = this.backImgUrl;
    data['postNum'] = this.postNum;
    data['fanNum'] = this.fanNum;
    data['followNum'] = this.followNum;
    data['isFollow'] = this.isFollow;
    return data;
  }
}