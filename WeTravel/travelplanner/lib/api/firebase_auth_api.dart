//api/firebase_auth_api.dart
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  User? getUser() {
    return auth.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //let's print the object returned by signInWithEmailAndPassword
      //you can use this object to get the user's id, email, etc.
      print(credential);
    } on FirebaseAuthException catch (e) {
      // if (e.code == 'user-not-found') {
      //   //possible to return something more useful
      //   //than just print an error message to improve UI/UX
      //   print('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   print('Wrong password provided for that user.');
      // }
      print('${e.code} and ${e.message}');
      throw Exception('Authentication Failed');
      // Check for the error code, universal catch for failed sign-in
    } catch (e) {
      throw Exception('Error');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<void> signUp(String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(credential.user?.email);
    } on FirebaseAuthException catch (e) {
      print('${e.code} and ${e.message}');
    }
  }
}