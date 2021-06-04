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
    return User.fromJson(snapshot.data());
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
}
