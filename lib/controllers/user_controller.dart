import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_start/models/user.dart' as lusr;
import 'package:social_start/services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  Future<void> createUser({lusr.User user}){
    return _userService.createUser(user);
  }

  Future<lusr.User> getUser([String uid = ""]){
    if(uid == ""){
      uid = FirebaseAuth.instance.currentUser.uid;
    }
    return _userService.getUser(uid);
  }

  Stream<DocumentSnapshot> getUserStream(String uid){
    return _userService.getUserStream(uid);
  }

  Future<void> updateUserPosts(String uid, lusr.User user) async{
    return await _userService.updateUserPosts(uid, user);
  }

  Future<void> followUser(followerId, userId) async {
    return await _userService.followUser(followerId, userId);
  }
}