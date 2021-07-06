class Chat {
  String id;
  String user1Id;
  String user2Id;
  String user1name;
  String user2name;

  Chat({this.id, this.user1Id, this.user2Id, this.user1name, this.user2name});

  Map<String, dynamic> toJson(){
    return {
      "id":id,
      "user1_id":user1Id,
      "user2_id":user2Id,
      "user1_name":user1name,
      "user2_name":user2name,
    };
  }
}