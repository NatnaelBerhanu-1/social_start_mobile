import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_start/models/user.dart';

import 'base_service.dart';

class UserService extends BaseService {
  Future<void> createUser(User user) async {
    return fireStore.collection("users").doc(user.uid).set(user.toJson());
  }

  Future<User> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await fireStore.collection("users").doc(uid).get();
    var user = User.fromJson(snapshot.data());
    user.uid = snapshot.id;
    return user;
  }

  Future<QuerySnapshot> searchUser({String value}) async {
    return FirebaseFirestore.instance
        .collection('users')
        .where('first_name', isGreaterThanOrEqualTo: value)
        .where('first_name', isLessThan: value + 'z')
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

      // userPosts.data().forEach((element) {
      //   print("userPosts: ${element.data().keys}");
      //   // updateObjects["posts/${element.id}/user"] = userUpdate;
      //   DocumentReference documentReference = fireStore.collection("posts").doc("${element.id}");
      //   transaction.update(documentReference, {"user": userUpdate});
      //   print("updated post");
      // });
    });
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return fireStore.collection("users").doc(uid).snapshots();
  }

  Future<void> followUser(followerId, userId) async{
    fireStore.runTransaction((transaction) async {
      try {
        DocumentReference followerRef = fireStore.collection("users").doc(
            followerId);
        DocumentReference userRef = fireStore.collection("users").doc(userId);

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
        transaction.update(followerRef, {"following": followerFollowing});

        transaction.update(userRef,
            {"total_followers": userSnapshot.get("total_followers") + 1});
        transaction.update(followerRef, {"following": followerFollowing});
      }catch(error, stk){
        throw Exception("some body handle this this");
      }
    });
  }
}
