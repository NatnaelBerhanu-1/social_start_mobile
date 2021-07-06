import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/user.dart' as lusr;
import 'package:social_start/services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  Future<void> createUser({lusr.User user}){
    return _userService.createUser(user);
  }

  Future<lusr.User> getUser([String uid = ""]) async{
    if(uid == ""){
      uid = FirebaseAuth.instance.currentUser.uid;
    }
    return await _userService.getUser(uid);
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

  Future<void> unFollowUser(followerId, userId) async {
    return await _userService.unFollowUser(followerId, userId);
  }

  Future<void> updateUserProfilePic({userId, String imageUrl}) async {
    return await _userService.updateUserProfilePIc(userId, imageUrl);
  }

  Future<dynamic> getChatId(userOneId, userTwoId) async{
    return await _userService.getChatId(userOneId, userTwoId);
  }

  Future<dynamic> createChat(Chat chat) async{
    return await _userService.createChat(chat);
  }

  Future<dynamic> purchaseSocialPoint(purchasedPoint) async {
    return await _userService.purchaseSocialPoint(purchasedPoint);
  }
}
