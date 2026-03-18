import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/api/firebase_todo_api.dart';
import '../../../../models/todo_model.dart';

class TodoListProvider with ChangeNotifier {
  Stream<QuerySnapshot>? _todosStream; //stream to listen for changes from Firestore
  final FirebaseTodoAPI firebaseService = FirebaseTodoAPI(); //instance of FirebaseTodoAPI -> interacts with Firestore

  // getter
  Stream<QuerySnapshot>? get todo => _todosStream;

  // TODO: get all todo items from Firestore
  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    notifyListeners();
  }

  // TODO: add todo item and store it in Firestore
  Future<void> addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson());
    print(message);
    notifyListeners();
  }

  // TODO: edit a todo item and update it in Firestore
  Future<void> editTodo(Todo newTodo) async {
    String message = await firebaseService.editTodo(newTodo);
    print(message);
    notifyListeners();
  }

  // TODO: delete a todo item and update it in Firestore
  Future<void> deleteTodo(String id) async {
    String message = await firebaseService.deleteTodo(id);
    print(message);
    notifyListeners();
  }

  // TODO: modify a todo status and update it in Firestore
  Future<void> toggleStatus(String id, bool status) async {
    String message = await firebaseService.toggleStatus(id, status);
    print(message);
    notifyListeners();
  }
}
