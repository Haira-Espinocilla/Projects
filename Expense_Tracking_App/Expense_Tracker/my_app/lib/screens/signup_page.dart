import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.blue),
      body: _createBody(),
    );
  }
  //creates text fields for the main body
  Widget _createBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _createTextField((value) => firstName = value, "First Name", _validateRequired),
            const SizedBox(height: 8),
            _createTextField((value) => lastName = value, "Last Name", _validateRequired),
            const SizedBox(height: 8),
            _createTextField((value) => email = value, "Email", _validateEmail),
            const SizedBox(height: 8),
            _createTextField((value) => password = value, "Password", _validatePassword, obscureText: true),
            const SizedBox(height: 8),
            _createTextField((value) => confirmPassword = value, "Confirm Password", _validateConfirmPassword, obscureText: true),
            const SizedBox(height: 16),
            _createCreateAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _createTextField(
    Function(String) onChanged,
    String label,
    String? Function(String?) validator,
    {bool obscureText = false}
  ) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      onChanged: onChanged, //updates the state with the input value
      validator: validator, //input checker
      obscureText: obscureText, //to hide the password into dots
    );
  }

  Widget _createCreateAccountButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            // create user in Firebase Authentication
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Account created successfully!'), backgroundColor: Colors.green),
            );
            Navigator.pop(context); // go back to sign in page
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to sign up: ${e.message}'), backgroundColor: Colors.red),
            );
          }
        }
      },
      child: const Text("Sign Up"),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~_]).{6,}$').hasMatch(value)) {
      return 'Password must have upper, lower, number, and special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
