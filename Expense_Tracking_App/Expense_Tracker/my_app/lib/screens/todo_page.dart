import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/screens/modal_detail.dart';
import 'package:provider/provider.dart';
import '../../../../models/todo_model.dart';
import '../../../../providers/todo_provider.dart';
import '../../../../providers/auth_provider.dart';
import 'modal_todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot>? todosStream = context.watch<TodoListProvider>().todo;

    return Scaffold(
      appBar: AppBar(title: const Text("Expenses"),
      actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              // sign out from FirebaseAuth
              await context.read<UserAuthProvider>().signOut();
              // go back to sign in page
              Navigator.of(context).pushReplacementNamed('/signIn');
            },
          ),
        ]
      ),
      body: StreamBuilder(
        stream: todosStream,
        builder: (context, snapshot) {
          //to display errors
          if (snapshot.hasError) {
            return Center(child: Text("Error encountered! ${snapshot.error}"));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          //if no expenses yet
          } else if (todosStream == null) {
            return const Center(child: Text("No Expenses Found"));
          }

          //render list of expenses from Firestore
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: ((context, index) {
              Todo todo = Todo.fromJson(
                snapshot.data?.docs[index].data() as Map<String, dynamic>,
              );
              todo.id = snapshot.data?.docs[index].id;
              //pwedeng i-swipe to delete
              return Dismissible(
                key: Key(todo.id.toString()),
                onDismissed: (direction) {
                  context.read<TodoListProvider>().deleteTodo(todo.id!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${todo.title} deleted')),
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(todo.title),
                  onTap: () {
                    // to show details of an expense
                    showDialog(
                      context: context,
                      builder: (_) => DetailModal(item: todo),
                    );
                  },
                  leading: Checkbox(
                    value: todo.paid,
                    onChanged: (bool? value) {
                      //toggling paid/unpaid status
                      context.read<TodoListProvider>().toggleStatus(
                        todo.id!,
                        value!,
                      );
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //for edit button
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext context) =>
                                    TodoModal(type: 'Edit', item: todo),
                          );
                        },
                        icon: const Icon(Icons.create_outlined),
                      ),
                      //for delete button
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (BuildContext context) =>
                                    TodoModal(type: 'Delete', item: todo),
                          );
                        },
                        icon: const Icon(Icons.delete_outlined),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => TodoModal(type: 'Add'),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
