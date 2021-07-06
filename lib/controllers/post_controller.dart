import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_start/models/comment.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user_like.dart';
import 'package:social_start/services/firebase_services.dart';

class PostController{
  FirebaseServices _firebaseServices = FirebaseServices();
  Future<void> createPost({Post post, File file, String extension}){
    return _firebaseServices.createPost(post: post, file: file, extension: extension);
  }

  Future<QuerySnapshot> getPosts(String type, String orderBy){
    return _firebaseServices.readPosts(type, orderBy);
  }

  Future<bool> addComment(Comment comment){
    return _firebaseServices.addComment(comment);
  }

  Future<bool> likePost(UserLike userLike){
    return _firebaseServices.likePost(userLike);
  }

  Future<bool> dislikePost(UserLike userLike){
    return _firebaseServices.dislikePost(userLike);
  }

  Future<void> countPostView(String postId){
    return _firebaseServices.countPostView(postId);
  }

  Future<QuerySnapshot> getUserPosts(String userId) {
    return _firebaseServices.getUserPosts(userId);
  }

  Future<void> awardPoint(String postId) async{
    return await _firebaseServices.awardPoint(postId);
  }
}