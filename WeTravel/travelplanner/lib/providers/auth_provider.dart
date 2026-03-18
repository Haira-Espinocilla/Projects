import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelplanner/models/user_model.dart';
import '../api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  FirebaseAuthAPI authService = FirebaseAuthAPI();
  User? user;
  Users? userData;

  UserAuthProvider() {
    fetchUser();
  }

  void fetchUser() {
    user = authService.getUser();
    if (user != null) {
      _fetchUserData(user!.email);
    }
    notifyListeners();
  }

  Future<void> _fetchUserData(String? email) async {
    if (email == null) return;
    final query = await FirebaseFirestore.instance
      .collection('users')
      .where('emailAddress', isEqualTo: email)
      .limit(1)
      .get();
    
    if (query.docs.isNotEmpty) {
      userData = Users.fromJson(query.docs.first.data());
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    print('Signing in...');
    await authService.signIn(email, password);
    fetchUser();
  }

  Future<void> signOut() async {
    print('Signing out...');
    await authService.signOut();
    user = null;
    userData = null;
    fetchUser();
  }

  Future<void> signUp(String email, String password) async {
    await authService.signUp(email, password);
    fetchUser();
  }
}