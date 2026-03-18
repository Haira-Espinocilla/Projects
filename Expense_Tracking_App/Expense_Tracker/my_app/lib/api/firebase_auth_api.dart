import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance; //instance of FirebaseAuth to access authentication services

  User? getUser() {
    return auth.currentUser;
  }

  //signs in the user using Firebase Authentication
  Future<void> signIn(String email, String password) async {
    UserCredential credential;
    try {
      credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential);
    } on FirebaseAuthException catch (e) {
      //print(e.code);
      if (e.code == 'user-not-found') {
        throw ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw ('Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        throw ('Wrong email or Password.');
      } else if (e.code == 'invalid-email'){
        throw ('Enter a valid email address.');
      } else {
        throw ('Error: ${e.message}');
      }
    }
  }

  //calls signOut method from FirebaseAuth to sign out user from the app
  Future<void> signOut() async {
    await auth.signOut();
  }
}
