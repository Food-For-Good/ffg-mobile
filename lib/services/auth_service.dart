import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Check if user is already logged in
  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  // Get email
  Future<String> getEmail() async {
    try {
      FirebaseUser currentUser = await _firebaseAuth.currentUser();
      currentUser.reload();
      currentUser = await _firebaseAuth.currentUser();
      return currentUser.email;
    } catch (e) {
      return e.toString();
    }
  }

  // SignUp
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    // update username
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
    currentUser = await _firebaseAuth.currentUser();
    return currentUser.uid;
  }

  // SignIn
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    currentUser.reload();
    currentUser = await _firebaseAuth.currentUser();
    return currentUser.uid;
  }

  // SignOut
  signOut() {
    return _firebaseAuth.signOut();
  }
}
