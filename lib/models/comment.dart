class Comment{
  String id;
  String userId;
  String userName;
  String userProfilePic;
  String createdAt;
  String postId;
  String content;

  Comment(
      {this.id,
      this.userId,
      this.userName,
      this.createdAt,
      this.postId,
      this.content,
      this.userProfilePic});
  
  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      userId: json['user_id'],
      userName: json['user_name'],
      content: json['content'],
      createdAt: json['created_at'],
      postId: json['post_id'],
      userProfilePic: json['user_profile_pic']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'user_id':userId,
      'user_name':userName,
      'content':content,
      'created_at':createdAt,
      'post_id':postId,
      'user_profile_pic': userProfilePic,
    };
  }
}