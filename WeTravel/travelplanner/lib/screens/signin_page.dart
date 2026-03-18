import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formkey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  String? usernameError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bgImage_23.png', fit: BoxFit.cover),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFAEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "WeTravel",
                        style: GoogleFonts.ubuntu(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF5F7060),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _createTextField(
                        (value) => username = value,
                        "Username",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          if (usernameError != null) {
                            return usernameError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _createTextField(
                        (value) => password = value,
                        "Password",
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _createSignInButton(context),
                      const SizedBox(height: 16),
                      _createSignUpButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTextField(
    Function(String) onChanged,
    String label, {
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: isPassword,
      style: GoogleFonts.ubuntu(),
      validator: validator,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.ubuntu(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _createSignInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5F7060),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onPressed: () async {
          final auth = context.read<UserAuthProvider>();
          final firestore = FirebaseFirestore.instance;

          // Look up username
          QuerySnapshot query =
              await firestore
                  .collection('users')
                  .where(
                    'userName', //search by userName to get the other user info
                    isEqualTo: username,
                  ) // 'email' actually holds the username here
                  .get();

          if (query.docs.isEmpty) {
            setState(() {
              usernameError = "Username not found"; // Set the error message
            });
            formkey.currentState!.validate(); // Trigger validation again
            return;
          } else {
            setState(() {
              usernameError = null; // Clear the error if username is found
            });
          }

          String emailFromDB = query.docs.first.get('emailAddress') as String;

          try {
            await auth.signIn(emailFromDB, password);
            Navigator.pushReplacementNamed(context, '/');
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Login failed: ${e.toString()}")),
            );
          }
        },
        child: Text(
          "LOG IN",
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: const Color(0xFFFCFAEE),
          ),
        ),
      ),
    );
  }

  Widget _createSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account yet? ", style: GoogleFonts.ubuntu()),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signUp'),
          child: Text(
            "Sign up",
            style: GoogleFonts.ubuntu(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}