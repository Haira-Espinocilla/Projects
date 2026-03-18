import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      await db.collection("users").add(user);
      return "Successfully added user!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllUsers() {
    return db.collection("users").snapshots();
  }

  // Future<String> deleteUser(String? id) async {
  //   try {
  //     await db.collection("users").doc(id).delete();
  //     return "Successfully deleted user!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }
}
