import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../api/firebase_user_api.dart';
import '../models/user_model.dart';

class UserListProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _userStream;
  late FirebaseTodoAPI firebaseService;

  UserListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchUsers();
  }

  // getter
  Stream<QuerySnapshot> get tracker => _userStream;

  // TODO: get all users from Firestore
  void fetchUsers() {
    _userStream = firebaseService.getAllUsers();
    notifyListeners();
  }

  // TODO: add user and store it in Firestore
  Future<void> addUser(Users item) async {
    String message = await firebaseService.addUser(item.toJson());
    print(message);
    notifyListeners();
  }
}
