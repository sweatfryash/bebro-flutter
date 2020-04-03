class ReceiveMsg {
  String fromUserId;
  String type;
  String content;

  ReceiveMsg({this.fromUserId, this.type, this.content});

  ReceiveMsg.fromJson(Map<String, dynamic> json) {
    fromUserId = json['fromUserId'];
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromUserId'] = this.fromUserId;
    data['type'] = this.type;
    data['content'] = this.content;
    return data;
  }
}