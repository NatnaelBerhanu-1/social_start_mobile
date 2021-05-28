import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/services/firebase_services.dart';

class PostController{
  FirebaseServices _firebaseServices = FirebaseServices();
  Future<void> createPost({Post post, File file, String extension}){
    return _firebaseServices.createPost(post: post, file: file, extension: extension);
  }

  Future<QuerySnapshot> getPosts(){
    return _firebaseServices.readPosts();
  }
}