import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';

import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String confirmPassword = "";
  String firstName = "";
  String lastName = "";
  String userName = "";
  String phoneNumber = "";
  List<String> interests = [];
  List<String> travelStyles = [];

  bool isCheckingUsername = false;
  String? usernameError;

  Future<bool> uniqueUsername(String username) async {
    final usernameQuery = await FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: username)
        .get();

    return usernameQuery.docs.isEmpty;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneNum = RegExp(r'^(\+63|0)?9\d{9}$');
    return phoneNum.hasMatch(value) ? null : 'Enter a valid phone number';
  }

  String? validatePassword(String? value) {
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

  void _submitForm() async {
    if (formkey.currentState!.validate()) {
      try {
        print("Signing up with email: $email and password: $password");
        await context.read<UserAuthProvider>().signUp(email, password);
        print('Account creation successful.');

        Users temp = Users(
          emailAddress: email,
          firstName: firstName,
          lastName: lastName,
          userName: userName,
          phoneNumber: phoneNumber,
          interests: interests,
          travelStyles: travelStyles,
        );

        await context.read<UserListProvider>().addUser(temp);
        Navigator.pop(context);
      } catch (e) {
        print("Sign-up error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Sign-up failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bgImage_23.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF8E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/signIn');
                          },
                        ),
                      ),
                      Text(
                        'WeTravel',
                        style: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Sign Up Now',
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFCF8E8),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStyledField(
                              "First Name",
                              (v) => firstName = v,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'First Name is required';
                                return null;
                              },
                            ),
                            _buildStyledField(
                              "Last Name",
                              (v) => lastName = v,
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Last Name is required';
                                return null;
                              },
                            ),
                            _buildStyledField(
                              "Email Address",
                              (v) => email = v,
                              validator: validateEmail,
                            ),
                            _buildStyledField(
                              "Phone Number",
                              (v) => phoneNumber = v,
                              validator: validatePhone,
                            ),
                            _buildStyledField(
                              "Username",
                              (v) {
                                userName = v;
                                Future.delayed(
                                  Duration(milliseconds: 500),
                                  () async {
                                    if (userName.isNotEmpty) {
                                      final unique = await uniqueUsername(
                                        userName,
                                      );
                                      if (!unique) {
                                        setState(() {
                                          usernameError =
                                              "Username is already taken";
                                        });
                                      } else {
                                        setState(() {
                                          usernameError = null;
                                        });
                                      }
                                    }
                                  },
                                );
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty)
                                  return 'Username is required';
                                if (usernameError != null) return usernameError;
                                return null;
                              },
                            ),

                            _buildStyledField(
                              "Password",
                              (v) => password = v,
                              isPassword: true,
                              validator: validatePassword,
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                "About Me",
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFF455A64),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Interests",
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: _buildChoiceChips(
                                options: [
                                  "Gaming",
                                  "Music",
                                  "Food",
                                  "History",
                                  "Travelling",
                                  "Sports",
                                  "Arts",
                                  "Others",
                                ],
                                selectedValues: interests,
                                onSelectionChanged: (newList) {
                                  setState(() {
                                    interests = newList;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Preferred Travel Styles",
                              style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 10,
                              children: _buildChoiceChips(
                                options: [
                                  "Backpacking",
                                  "Luxury",
                                  "Road Trips",
                                  "Cultural Tours",
                                  "Cruises",
                                ],
                                selectedValues: travelStyles,
                                onSelectionChanged: (newList) {
                                  setState(() {
                                    travelStyles = newList;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  backgroundColor: const Color(0xFF607D69),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _submitForm,
                                child: Text(
                                  "SIGN UP",
                                  style: GoogleFonts.ubuntu(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildChoiceChips({
  required List<String> options,
  required List<String> selectedValues,
  required Function(List<String>) onSelectionChanged,
}) {
  return options.map((option) {
    final isSelected = selectedValues.contains(option);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8),
      child: FilterChip(
        label: Text(
          option,
          style: GoogleFonts.ubuntu(
            fontSize: 14,
            color: isSelected ? Colors.white : Color(0xFF455A64),
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        selected: isSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Color(0xFF607D69)),
        selectedColor: const Color(0xFF607D69),
        backgroundColor: const Color(0xFFFCF8E8),
        checkmarkColor: Colors.white,
        onSelected: (selected) {
          final updated = [...selectedValues];
          selected ? updated.add(option) : updated.remove(option);
          onSelectionChanged(updated);
        },
      ),
    );
  }).toList();
}

Widget _buildStyledField(
  String label,
  Function(String) onChanged, {
  bool isPassword = false,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14.0),
    child: TextFormField(
      onChanged: onChanged,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w500),
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black87, width: 1.2),
        ),
      ),
    ),
  );
}
