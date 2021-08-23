import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchaser_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/utils/service_locator.dart';
import 'package:social_start/utils/utility.dart';
import 'package:jiffy/jiffy.dart';

enum UserStatus { success, failed, loading }

class UserViewModel extends ChangeNotifier {
  UserController _userController = getIt<UserController>();
  User user;
  UserStatus userStatus = UserStatus.loading;

  UserViewModel() {
    // getUser();
  }

  getUser() async {
    try {
      userStatus = UserStatus.loading;
      notifyListeners();
      user = await _userController.getUser(Utility.getUserId());
      userStatus = UserStatus.success;
      notifyListeners();
      checkSubscription();
    } catch (error, stk) {
      print("ERROR HERE");
      print(error);
      print(stk);
      userStatus = UserStatus.failed;
      notifyListeners();
    }
  }

  updateUser(User newUser) {
    this.user = newUser;
    print(newUser.firstName);
    notifyListeners();
  }

  checkSubscription() async {
    if (user.subscriptions == null) {
      return;
    }
    print("checking subscription");
    const entitlementID = "level 1";
    const entitlementIDs = [
      "level 1",
      "level 2",
      "level 3",
      "level 4",
      "level 5"
    ];
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
      entitlementIDs.forEach((element) {
        if (purchaserInfo.entitlements.all[element] != null &&
            purchaserInfo.entitlements.all[element].isActive == true) {
          print("User has subscription $element");
          // check if user hasn't get monthly point
          SubscriptionDetail subscriptionDetail = user.subscriptions[element];
          var timeDiff = Timestamp.now()
              .toDate()
              .difference(subscriptionDetail.updatedAt.toDate())
              .inDays;
          var jiffy1 = Jiffy(Timestamp.now().toDate());
          var jiffy2 = Jiffy(subscriptionDetail.updatedAt.toDate());
          print("jiffy ${jiffy1.diff(jiffy2, Units.MONTH)}");
          int monthDiff = jiffy1.diff(jiffy2, Units.MONTH);
          if (monthDiff == 1) {
            getIt<UserController>().addSubscription(SubscriptionDetail(
                socialPoint: subscriptionDetail.socialPoint,
                subscribedAt: subscriptionDetail.subscribedAt,
                updatedAt: Timestamp.now(),
                entitlementId: subscriptionDetail.entitlementId));
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }
}
