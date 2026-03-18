import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/todo_page.dart';
import '../providers/auth_provider.dart';
import 'signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserAuthProvider>().user;
    print(user);
    return user != null ? const TodoPage() : const SignIn();
  }
}
