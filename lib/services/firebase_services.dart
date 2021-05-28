import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:social_start/models/post.dart';
import 'package:social_start/models/user.dart' as usr;
import 'package:social_start/services/user_service.dart';
import 'package:social_start/utils/utility.dart';
import 'package:uuid/uuid.dart';

class FirebaseServices{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final UserService _userService = UserService();
  Uuid uuid = Uuid();

  Future<String> uploadImage(File file, String extension, String directory) async {
    TaskSnapshot snapshot = await _firebaseStorage.ref(
        "$directory/${uuid.v4()}$extension").putFile(file);

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> createPost({Post post, File file, String extension}) async{
    try {
      print("creating post");
      post.fileUrl = await uploadImage(file, extension, "post_uploads");
      var user = await _userService.getUser(FirebaseAuth.instance.currentUser.uid);
      post.user = usr.User(
        firstName: user.firstName,
        lastName: user.lastName,
        profileUrl: user.profileUrl
      );
      String postId = uuid.v4();
      await _fireStore.collection("posts").doc(postId).set(
          post.toJson())
          .onError((error, stackTrace) {
        print("error creating post");
        throw Exception("error creating post");
      });
      await _fireStore.collection("userPosts").doc(Utility.getUserId()).set({postId:true});
      return null;
    }catch(error, stacktrace){
      print(error);
      print(stacktrace);
      throw Exception("error creating post");
    }
  }

  Future<QuerySnapshot> readPosts() async {
    var postsRef =  await _fireStore.collection("posts").get().onError((error, stackTrace){
      throw Exception("failed to fetch posts");
    });
    return postsRef;
  }
}