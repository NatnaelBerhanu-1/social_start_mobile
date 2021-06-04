import 'package:social_start/models/user.dart';
import 'package:social_start/services/user_service.dart';

class UserController {
  final UserService _userService = UserService();

  Future<void> createUser({User user}) {
    return _userService.createUser(user);
  }

  Future<User> getUser(String uid) {
    return _userService.getUser(uid);
  }

  Future<void> updateUserPosts(String uid, User user) async {
    return await _userService.updateUserPosts(uid, user);
  }
}
