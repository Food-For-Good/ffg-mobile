import 'package:FoodForGood/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  // Future and stream that will be used to check the login status of the user.
  Future<FirebaseUser> get getUser => _firebaseAuth.currentUser();
  Stream<FirebaseUser> get user => _firebaseAuth.onAuthStateChanged;

  // Get email.
  Future<String> getEmail() async {
    try {
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      currentUser.reload();
      currentUser = await _firebaseAuth.currentUser();
      return currentUser.email;
    } catch (error) {
      return error.toString();
    }
  }

  // Get current username.
  Future<String> getUsername() async {
    String email = await this.getEmail();
    try {
      var document = await _firestore.document('users/$email').get();
      return document.data['username'];
    } catch (error) {
      return error.toString();
    }
  }

  // SignUp.
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      await currentUser.reload();
      await currentUser.sendEmailVerification();
      // update username
      var userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      await currentUser.updateProfile(userUpdateInfo);
    } catch (e) {
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      await currentUser.reload();
      await currentUser.sendEmailVerification();
      kShowFlushBar(
          content: 'Verification code sent again.', customError: true);
    }
    return '';
  }

  // SignIn.
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      currentUser.reload();
      currentUser = await _firebaseAuth.currentUser();
      if (currentUser.isEmailVerified) {
        return currentUser.uid;
      }
      return null;
    } catch (e) {}
  }

  // Reset Password.
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // SignOut.
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
