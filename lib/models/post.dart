import 'package:cloud_firestore/cloud_firestore.dart';
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
  double lat;
  double long;
  Timestamp createdAt;
  int views = 0;
  int points = 0;

  Post({this.id, this.fileUrl, this.caption, this.categoryId, this.userId, this.user, this.type = "picture", this.comments = 0, this.likes = 0,
  this.lat, this.long, this.createdAt, this.views = 0, this.points = 0});
  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json['id'],
      fileUrl: json['file_url'],
      caption: json['caption'],
      categoryId: json['category_id'],
      userId: json['user_id'],
      type: json['type'],
      user: User.forPost  (json['user']),
      likes: json['likes'],
      comments: json['comments'],
      lat:  json['lat'],
      long: json['long'],
      createdAt: json['created_at'],
      views: json['views'],
      points:json['points']
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
      'comments': comments,
      'lat':lat,
      'long':long,
      'created_at': createdAt,
      'views':views,
      'points': points
    };
  }
}