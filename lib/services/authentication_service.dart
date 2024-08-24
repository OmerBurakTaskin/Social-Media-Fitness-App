import "package:firebase_auth/firebase_auth.dart";

class AuthenticationService {
  static var auth = FirebaseAuth.instance;
  static User? user = auth.currentUser;

  static bool emailVerified =
      user == null ? false : auth.currentUser!.emailVerified;

  static Future<UserCredential> signinWithEmailPassword(
      String email, String password) async {
    try {
      var userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  static Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      var userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  static logOut() async {
    await auth.signOut();
  }

  static Future<void> sendVerificationMail() async {
    try {
      if (user != null) {
        await user?.sendEmailVerification();
      } else {
        await user?.reload();
      }
    } catch (e) {
      throw Error();
    }
  }

  static Future<bool> checkEmailVerification() async {
    var user = auth.currentUser;
    await user?.reload();
    user = auth.currentUser;
    emailVerified = user == null ? false : user.emailVerified;
    print("MAİL VERİFİCATİON: " + emailVerified.toString());
    return emailVerified;
  }
}
