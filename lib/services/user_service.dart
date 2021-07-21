import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/utils/utility.dart';

import 'base_service.dart';

class UserService extends BaseService {
  Future<void> createUser(User user) async {
    return fireStore.collection("users").doc(user.uid).set(user.toJson());
  }

  Future<User> getUser(String uid) async {
    print("GETUSER $uid");
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection("users").doc(uid).get();
    var user = User.fromJson(snapshot.data());
    user.uid = snapshot.id;
    // print("social point: ${user.socialPoint.permanent}");
    return user;
  }

  Future<QuerySnapshot> searchUser({String value}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('first_name_lowercase', isGreaterThanOrEqualTo: value)
        .where('first_name_lowercase', isLessThan: value + 'z')
        .get();
  }

  Future<void> updateUserPosts(String uid, User user) async {
    DocumentSnapshot<Map<String, dynamic>> userPosts =
        await fireStore.collection("userPosts").doc(uid).get();
    final Map<String, dynamic> userUpdate = {
      "first_name": user.firstName,
      "last_name": user.lastName,
      "profile_url": user.profileUrl
    };
    print("userPosts: ${userPosts.data()}");
    await fireStore.runTransaction((transaction) async {
      userPosts.data().forEach((key, value) {
        DocumentReference documentReference =
            fireStore.collection("posts").doc("$key");
        transaction.update(documentReference, {"user": userUpdate});
        print("updated post");
      });
    });
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return fireStore.collection("users").doc(uid).snapshots();
  }

  Future<void> followUser(followerId, userId) async {
    print("$followerId $userId");
    await fireStore.runTransaction((transaction) async {
      try {
        DocumentReference followerRef =
            fireStore.collection("users").doc(followerId);
        DocumentReference userRef = fireStore.collection("users").doc(userId);
        QuerySnapshot userPosts = await fireStore
            .collection("posts")
            .where("user_id", isEqualTo: userId)
            .get();

        DocumentSnapshot followerSnapshot = await transaction.get(followerRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        List<dynamic> followerFollowing = followerSnapshot.get("following");
        List<dynamic> userFollowers = followerSnapshot.get("followers");

        followerFollowing.add(userId);
        userFollowers.add(followerId);

        transaction.update(followerRef, {
          "total_following": followerSnapshot.get("total_following") + 1,
          "following": followerFollowing
        });
        transaction.update(
          userRef,
          {
            "total_followers": userSnapshot.get("total_followers") + 1,
            "followers": userFollowers
          },
        );

        // DocumentSnapshot<Map<String, dynamic>> userDoc =
        // await transaction.get(userRef);
        // User user = User.fromJson(userDoc.data());
        //
        // userPosts.docs.forEach((element) {
        //   transaction.update(element.reference, {"user": user.toJson()});
        //   print("updated post");
        // });
      } catch (error, stk) {
        print(error);
        print(stk);
        throw Exception("Follow failed");
      }
    });
  }

  Future<void> unFollowUser(followerId, userId) async {
    print("UserId: $userId followerId: $followerId");
    await fireStore.runTransaction((transaction) async {
      try {
        DocumentReference followerRef =
            fireStore.collection("users").doc(followerId);
        DocumentReference userRef = fireStore.collection("users").doc(userId);
        QuerySnapshot userPosts = await fireStore
            .collection("posts")
            .where("user_id", isEqualTo: userId)
            .get();

        DocumentSnapshot followerSnapshot = await transaction.get(followerRef);
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        List<dynamic> followerFollowing = followerSnapshot.get("following");
        List<dynamic> userFollowers = followerSnapshot.get("followers");

        followerFollowing.remove(userId);
        userFollowers.remove(followerId);

        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await transaction.get(userRef);
        User user = User.fromJson(userDoc.data());

        transaction.update(followerRef, {
          "total_following": followerSnapshot.get("total_following") - 1,
          "following": followerFollowing
        });
        transaction.update(
          userRef,
          {
            "total_followers": userSnapshot.get("total_followers") - 1,
            "followers": userFollowers
          },
        );

        userPosts.docs.forEach((element) {
          transaction.update(element.reference, {"user": user.toJson()});
          print("updated post");
        });
      } catch (error, stk) {
        print(error);
        print(stk);
        throw Exception("UnFollow failed");
      }
    });
  }

  Future<void> updateUserProfilePIc(userId, String imageUrl) async {
    QuerySnapshot userPosts = await fireStore
        .collection("posts")
        .where("user_id", isEqualTo: userId)
        .get();
    QuerySnapshot userComments = await fireStore
        .collection("comments")
        .where("user_id", isEqualTo: userId)
        .get();
    DocumentReference userRef = fireStore.collection("users").doc(userId);
    await fireStore.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await transaction.get(userRef);
      User user = User.fromJson(userDoc.data());
      transaction.update(userRef, {"profile_url": imageUrl});
      print("User_posts ${userPosts.docs.length}");
      userPosts.docs.forEach((element) {
        user.profileUrl = imageUrl;
        transaction.update(element.reference, {"user": user.toJson()});
        print("updated post");
      });
      print("Updating comments");
      userComments.docs.forEach((element) {
        transaction.update(element.reference, {"user_profile_pic": imageUrl});
      });
    });
  }

  Future<dynamic> getChatId(userOneId, userTwoId) async {
    var chatId;
    QuerySnapshot chatSnapshot = await fireStore
        .collection("chats")
        .where("user1_id", isEqualTo: userOneId)
        .get();
    print(chatSnapshot.docs);
    chatSnapshot.docs.forEach((DocumentSnapshot element) {
      if (element.get("user2_id") == userTwoId) {
        chatId = element.id;
        return;
      }
    });
    if (chatId == null) {
      QuerySnapshot chatSnapshot2 = await fireStore
          .collection("chats")
          .where("user1_id", isEqualTo: userTwoId)
          .get();
      print(chatSnapshot2.docs);
      chatSnapshot2.docs.forEach((DocumentSnapshot element) {
        if (element.get("user2_id") == userTwoId) {
          chatId = element.id;
          return;
        }
      });
    }
    print("chatId: $chatId");
    return chatId;
  }

  Future<dynamic> createChat(Chat chat) async {
    var ch = await fireStore.collection("chats").add(chat.toJson());
    return ch.id;
  }

  Future<void> purchaseSocialPoint(purchasedPoint) async {
    DocumentReference<Map<String, dynamic>> usrRef =
        fireStore.collection("users").doc(Utility.getUserId());
    DocumentSnapshot<Map<String, dynamic>> usr = await usrRef.get();
    User user = User.fromJson(usr.data());
    user.socialPoint.permanent = user.socialPoint.permanent + purchasedPoint;
    usrRef.update({'social_point': user.socialPoint.toJson()});
  }
}
