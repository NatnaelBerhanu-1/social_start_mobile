import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_start/models/chat.dart';
import 'package:social_start/models/transaction.dart' as lTransaction;
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

  Future<void> addSubscription(SubscriptionDetail subDetail) async {
    DocumentReference<Map<String, dynamic>> usrRef =
        fireStore.collection("users").doc(Utility.getUserId());
    DocumentSnapshot<Map<String, dynamic>> usr = await usrRef.get();
    User user = User.fromJson(usr.data());
    user.socialPoint.permanent =
        user.socialPoint.permanent + subDetail.socialPoint;
    usrRef.update({'social_point': user.socialPoint.toJson()});
    Map<String, dynamic> subs = {};
    user.subscriptions.forEach((key, value) {
      subs[key] = value.toJson();
    });
    subs[subDetail.entitlementId] = subDetail.toJson();
    usrRef.update({'subscriptions': subs});
  }

  Future<List<User>> getLeaderBoards() async {
    Query<Map<String, dynamic>> queryRef = fireStore
        .collection("users")
        .orderBy('likes', descending: true)
        .limit(5);

    QuerySnapshot snapshot = await queryRef.get();
    List<User> users = [];
    print("users users");
    print(snapshot.docs);

    snapshot.docs.forEach((element) {
      users.add(User.fromJson(element.data()));
    });

    return users;
  }

  Future<void> updateUser(User user) async {
    DocumentReference userRef =
        fireStore.collection("users").doc(Utility.getUserId());
    return userRef.update(user.toJson());
  }

  Future<void> tipUser(
      User tipper, User reciever, tipAmount, transactionId, String message,
      [paymentProvider = "paypal"]) async {
    // add transaction
    // fireStore.collection("transactions").add({"amount": tipAmount});
    fireStore.runTransaction((transaction) async {
      DocumentReference transactionRef =
          fireStore.collection("transactions").doc();
      // DocumentReference chatRef = fireStore.collection("chats").doc();
      DocumentReference messagesRef = fireStore.collection("messages").doc();
      // DocumentReference tipperRef =
      //     fireStore.collection("users").doc(tipper.uid);
      DocumentReference recieverRef =
          fireStore.collection("users").doc(reciever.uid);

      DocumentSnapshot recieverSnapshot = await transaction.get(recieverRef);
      print(recieverSnapshot.data());
      double updatedBalance = recieverSnapshot.get("balance") + tipAmount;

      // datas
      var transactionData = lTransaction.Transaction(
              amount: tipAmount,
              from: tipper.uid,
              to: reciever.uid,
              paymnentProvider: paymentProvider,
              transactionId: transactionId)
          .toMap();

      transaction.set(transactionRef, transactionData);
      transaction.update(recieverRef, {"balance": updatedBalance});
      if (message.isNotEmpty) {
        // get chat if exists
        var chat = Chat(
            lastMessage: message,
            user1Id: tipper.uid,
            user2Id: reciever.uid,
            lastMessageBy: tipper.uid,
            user1name: tipper.firstName,
            user2name: reciever.firstName,
            user1ProfilePic: tipper.profileUrl,
            user2ProfilePic: reciever.profileUrl);
        var chatId = await this.getChatId(tipper.uid, reciever.uid);
        if (chatId == null) {
          chatId = await this.createChat(chat);
        }

        Map<String, dynamic> messageData = {
          "chat_id": chatId,
          "content": message,
          "reciever_id": reciever.uid,
          "sender_id": tipper.uid,
          "timestamp": Timestamp.now()
        };

        transaction.set(messagesRef, messageData);
      }
    });

    return;
  }
}
