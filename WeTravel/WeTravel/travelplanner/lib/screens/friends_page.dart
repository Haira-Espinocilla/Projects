import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:travelplanner/providers/auth_provider.dart';
import 'dart:convert';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  String? profileBase64;

  User? currentUser;
  String currentUserEmail = '';

  late Future<List<Map<String, dynamic>>> _friendsListFuture;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    currentUserEmail = currentUser?.email ?? '';

    _friendsListFuture = _fetchFriends();
    _fetchUserPfp();
  }

  Future<void> _fetchUserPfp() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('emailAddress', isEqualTo: user.email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      setState(() {
        profileBase64 = data['profileImage'] ?? '';
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final currentUserEmail = context
          .read<UserAuthProvider>()
          .userData
          ?.emailAddress;
      if (currentUser == null) return [];

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) return [];

      final userData = userSnapshot.docs.first.data();
      final List<String> friendEmails = List<String>.from(
        userData['friends'] ?? [],
      );

      if (friendEmails.isEmpty) {
        print("No friends :()");
        return [];
      }

      final friendsQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', whereIn: friendEmails)
          .get();

      final List<Map<String, dynamic>> friendsData = [];
      for (final doc in friendsQuery.docs) {
        final data = doc.data();
        friendsData.add({
          'userName': data['userName'] ?? 'Unknown',
          'emailAddress': data['emailAddress'],
          'uid': doc.id,
          'profileImage': data['profileImage'] ?? '',
          'firstName': data['firstName'] ?? '',
            'lastName': data['lastName'] ?? '',
            'phoneNumber': data['phoneNumber'] ?? '',
            'interests': data['interests'] ?? '',
            'travelStyles': data['travelStyles'] ?? '',
            
        });
      }
      return friendsData;
    } catch (e) {
      return [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAEE),
        title: Text(
          'Friends',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5F7060),
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFEEE6CF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _friendsListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading matches',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Match Found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  final users = snapshot.data!;
                  return SizedBox(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/otherProfile',
                              arguments: user,
                            );
                          },
                          child: Card(
                            color: const Color(0xFFFCFAEE),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: CircleAvatar(
                                radius: 24,
                                backgroundImage:
                                    (user['profileImage'] != null &&
                                        (user['profileImage'] as String)
                                            .isNotEmpty)
                                    ? MemoryImage(
                                        base64Decode(user['profileImage']),
                                      )
                                    : const AssetImage(
                                            'assets/images/default_icon.png',
                                          )
                                          as ImageProvider,
                              ),

                              title: Text(
                                user['userName'] ?? user['emailAddress'] ?? 'unknown',
                                style: GoogleFonts.ubuntu(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                user['emailAddress'],
                                style: GoogleFonts.ubuntu(fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
