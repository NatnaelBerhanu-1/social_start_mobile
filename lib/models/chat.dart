class Chat {
  String id;
  String user1Id;
  String user2Id;
  String user1name;
  String user2name;
  String user1ProfilePic;
  String user2ProfilePic;
  String lastMessage = "";
  String lastMessageBy;

  Chat({this.id, this.user1Id, this.user2Id, this.user1name, this.user2name, this.user1ProfilePic, this.user2ProfilePic, this.lastMessage="", this.lastMessageBy});

  Map<String, dynamic> toJson(){
    return {
      "id":id,
      "user1_id":user1Id,
      "user2_id":user2Id,
      "user1_name":user1name,
      "user2_name":user2name,
      "user1_profile_url": user1ProfilePic,
      "user2_profile_url":user2ProfilePic,
      "last_message":lastMessage,
      "last_message_by": lastMessageBy
    };
  }

  factory Chat.fromJson(Map<String, dynamic> json){
    return Chat(
      user1name: json['user1_name'],
      user2name: json['user2_name'],
      user1Id: json['user1_id'],
      user2Id: json['user2_id'],
      user1ProfilePic: json['user1_profile_url'],
      user2ProfilePic: json['user2_profile_url'],
      lastMessage: json['last_message'],
      lastMessageBy: json['last_message_by']
    );
  }
}