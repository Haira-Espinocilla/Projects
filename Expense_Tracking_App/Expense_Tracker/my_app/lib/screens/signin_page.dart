import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/todo_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.blue),
      body: _createBody(context),
    );
  }

  //creates text fields for the main body
  Widget _createBody(BuildContext context) {
    return Form(
      key: formkey,
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          children: [
            _createTextField((value) => email = value, "Email"),
            const SizedBox(height: 8),
            _createTextField((value) => password = value, "Password", obscureText: true),
            const SizedBox(height: 16),
            _createSignInButton(context),
            _createSignUpButton(context),
          ],
        ),
      ),
    );
  }


  Widget _createTextField(Function(String) onChanged, String label, {bool obscureText = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      obscureText: obscureText,
      //to make sure all fields have values
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${label} is required';
        }
        return null;
      },
    );
  }

  Widget _createSignInButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () async {
      if (formkey.currentState?.validate() ?? false) {
        try {
          await context.read<UserAuthProvider>().signIn(email, password); //attempts to sign in using UserAuthProvider
          context.read<TodoListProvider>().fetchTodos(); //fetch the user's list after signing in
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    },
    child: const Text("Sign In"),
  );
}

  Widget _createSignUpButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        //go to sign up page
        Navigator.pushNamed(context, '/signUp');
      },
      child: const Text("Sign Up"),
    );
  }
}
