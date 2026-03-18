import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  FirebaseAuthAPI authService = FirebaseAuthAPI(); //instance of FirebaseAuthAPI -> interacts with Firebase Authentication
  User? user; //current user

  UserAuthProvider() {
    fetchUser();
  }

  void fetchUser() {
    user = authService.getUser(); //get current user
    notifyListeners();
  }
  //calls signIn method (from FirebaseAuthAPI), then fetch the user after sign in
  Future<void> signIn(String email, String password) async {
    print('Signing in...');
    await authService.signIn(email, password);
    fetchUser();
  }
  
  //calls signOut method (from FirebaseAuthAPI), then fetch the user to update user state
  Future<void> signOut() async {
    print('Signing out...');
    await authService.signOut();
    fetchUser();
  }
}
