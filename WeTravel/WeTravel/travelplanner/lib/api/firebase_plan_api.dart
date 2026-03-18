import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePlanApi {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addPlan(Map<String, dynamic> plan) async {
    try {
      await db.collection("plans").add(plan);
      return "Successfully added plan!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> updatePlan(String docId, Map<String, dynamic> updatedData) async {
    try {
      await db.collection("plans").doc(docId).update(updatedData);
      return "Successfully added plan!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllPlans() {
    return db.collection("plans").snapshots();
  }

  Stream<QuerySnapshot> getPlansByEmail(String email) {
    return db.collection("plans").where("email", isEqualTo: email).snapshots();
  }

  Future<Map<String, dynamic>?> getPlanById(String docId) async {
    final docSnapshot = await db.collection("plans").doc(docId).get();
    return docSnapshot.exists ? docSnapshot.data() : null;
  }

  Future<String> deletePlan(String docId) async {
    try {
      await db.collection("plans").doc(docId).delete();
      return "Successfully deleted plan!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}