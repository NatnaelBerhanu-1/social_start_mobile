import 'package:flutter/foundation.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/controllers/user_controller.dart';
import 'package:social_start/models/user.dart';
import 'package:social_start/utils/service_locator.dart';
import 'package:social_start/utils/utility.dart';

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
    } catch (error) {
      print("ERROR HERE");
    print(error);
      userStatus = UserStatus.failed;
      notifyListeners();

    }
  }
}
