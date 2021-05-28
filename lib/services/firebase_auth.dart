import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential  result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = result.user;
    return user.uid;
  }

  User getCurrentUser(){
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  void sendEmailVerification() {
    User user = _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  bool isEmailVerified() {
    User user = _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}