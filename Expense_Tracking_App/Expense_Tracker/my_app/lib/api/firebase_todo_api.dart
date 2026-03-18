import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/models/todo_model.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllTodos() {
    String userId = FirebaseAuth.instance.currentUser!.uid; //to get current user's id
    return db.collection("todos").where('userId', isEqualTo: userId).snapshots(); //return stream of the user's todos
  }

  //to add an item
  Future<String> addTodo(Map<String, dynamic> todo) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid; //get the current user's id
      todo['userId'] = userId; //associate todo with the user's id
      await db.collection("todos").add(todo);
      return "Successfully added todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //to delete an item
  Future<String> deleteTodo(String? id) async {
    try {
      await db.collection("todos").doc(id).delete();
      return "Successfully deleted todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  //to edit an item
  Future<String> editTodo(Todo newTodo) async {
  try {
    await db.collection("todos").doc(newTodo.id).update(newTodo.toJson());
    return "Successfully edited todo!";
  } on FirebaseException catch (e) {
    return "Failed with error '${e.code}: ${e.message}";
  }
}

  //for toggling of the paid status in Firestore
  Future<String> toggleStatus(String id, bool status) async {
    try {
      await db.collection("todos").doc(id).update({"paid": status});
      return "Successfully edited todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
