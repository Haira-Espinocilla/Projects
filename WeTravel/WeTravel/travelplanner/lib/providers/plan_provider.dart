import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_plan_api.dart';
import '../models/plan_model.dart';

class PlanListProvider with ChangeNotifier {
  late Stream<QuerySnapshot> _plansStream;
  late FirebasePlanApi _firebaseService;

  PlanListProvider() {
    _firebaseService = FirebasePlanApi();
  }

  // getter
  Stream<QuerySnapshot> get tracker => _plansStream;

  // TODO: get all users from Firestore
  void fetchPlans() {
    _plansStream = _firebaseService.getAllPlans();
  }

  void fetchPlansByEmail(String email) {
    _plansStream = _firebaseService.getPlansByEmail(email);
  }

  Future<Map<String, dynamic>?> fetchPlanById(String docId) async {
    return await _firebaseService.getPlanById(docId);
  }

  // TODO: add user and store it in Firestore
  Future<void> addPlan(Plans item) async {
    String message = await _firebaseService.addPlan(item.toJson());
    print(message);
    notifyListeners();
  }

  Future<void> updatePlan(String docId, Plans updatedPlan) async {
    String message = await _firebaseService.updatePlan(docId, updatedPlan.toJson());
    print(message);
    notifyListeners();
  }

  Future<void> deletePlan(String docId) async {
    String message = await _firebaseService.deletePlan(docId);
    print(message);
    notifyListeners();
  }
}