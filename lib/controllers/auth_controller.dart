import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_start/services/firebase_auth.dart';

class AuthController{
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  Future<String> signIn(String email, String password) async {
    return _firebaseAuthService.signIn(email, password);
  }

  Future<String> signUp(String email, String password) async {
    return _firebaseAuthService.signUp(email, password);
  }

  User getCurrentUser()  {
    return _firebaseAuthService.getCurrentUser();
  }

  Future<void> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  void sendEmailVerification() {
    _firebaseAuthService.sendEmailVerification();
  }

  bool isEmailVerified() {
    return _firebaseAuthService.isEmailVerified();
  }
}