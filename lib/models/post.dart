import 'package:social_start/models/user.dart';

class Post{
  String id;
  String fileUrl;
  String caption;
  String categoryId;
  String type = "picture";
  String userId;
  User user;
  int likes = 0;
  int comments = 0;

  Post({this.id, this.fileUrl, this.caption, this.categoryId, this.userId, this.user, this.type = "picture", this.comments = 0, this.likes = 0});
  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json['id'],
      fileUrl: json['file_url'],
      caption: json['caption'],
      categoryId: json['category_id'],
      userId: json['user_id'],
      type: json['type'],
      user: User.fromJson(json['user']),
      likes: json['likes'],
      comments: json['comments']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'file_url': this.fileUrl,
      'caption': this.caption,
      'category_id': this.categoryId,
      'user_id': this.userId,
      'type': this.type,
      'user':this.user.toJson(),
      'likes': likes,
      'comments': comments
    };
  }
}