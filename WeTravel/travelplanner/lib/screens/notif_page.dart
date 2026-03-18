//screens/profile_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  String userName = '';
  String phoneNumber = '';
  String fullName = '';
  User? currentUser;

  List<String> _incomingRequestEmails = [];
  List<Map<String, dynamic>> _incomingRequestDetails = [];

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  //initial code to fetch the user's data (might be revised in the future)
  Future<void> _fetchUserData() async {
    if (currentUser == null) return;
    final query =
        await FirebaseFirestore.instance
            .collection('users') //collection named 'users'
            .where('emailAddress', isEqualTo: currentUser!.email)
            .limit(1)
            .get(); //fetch the document
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      //print('Fetched user data: $data');
      setState(() {
        fullName =
            "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
        userName = data['userName'] ?? '';
        _incomingRequestEmails = List<String>.from(
          data['incomingRequest'] ?? [],
        );
      });
      await _fetchIncomingRequestDetails();
    }
  }

  Future<void> _fetchIncomingRequestDetails() async {
    List<Map<String, dynamic>> details = [];
    if (_incomingRequestDetails.isEmpty) {
      setState(() {
        _incomingRequestDetails = [];
      });
    }

    for (String senderEmail in _incomingRequestEmails) {
      try {
        final senderQuery =
            await FirebaseFirestore.instance
                .collection('users')
                .where('emailAddress', isEqualTo: senderEmail)
                .limit(1)
                .get();
        if (senderQuery.docs.isNotEmpty) {
          final senderData = senderQuery.docs.first.data();
          details.add({
            'email': senderEmail,
            'userName': senderData['userName'] ?? 'Unknown User',
            'firestoreDocId': senderQuery.docs.first.id,
          });
        }
      } catch (e) {
        print('Error');
      }
    }

    setState(() {
      _incomingRequestDetails = details;
    });
  }

  Future<void> _acceptRequest(
    String senderEmail,
    String senderFirestoreDocId,
  ) async {
    try {
      final currentUserEmail = currentUser!.email!;

      final currentUserDocQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('emailAddress', isEqualTo: currentUserEmail)
              .limit(1)
              .get();
      final currentUserDocRef = currentUserDocQuery.docs.first.reference;

      final senderDocQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('emailAddress', isEqualTo: senderEmail)
              .limit(1)
              .get();
      final senderDocRef = senderDocQuery.docs.first.reference;

      await currentUserDocRef.update({
        'incomingRequest': FieldValue.arrayRemove([senderEmail]),
      });

      await currentUserDocRef.update({
        'friends': FieldValue.arrayUnion([senderEmail]),
      });

      await senderDocRef.update({
        'outgoingRequest': FieldValue.arrayRemove([currentUserEmail]),
      });

      await senderDocRef.update({
        'friends': FieldValue.arrayUnion([currentUserEmail]),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Accepted"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
      await _fetchUserData();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed"), 
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
    }
  }

  Future<void> _rejectRequest(
    String senderEmail,
    String senderFirestoreDocId,
  ) async {
    try {
      final currentUserEmail = currentUser!.email!;

      final currentUserDocQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('emailAddress', isEqualTo: currentUserEmail)
              .limit(1)
              .get();
      final currentUserDocRef = currentUserDocQuery.docs.first.reference;

      final senderDocQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('emailAddress', isEqualTo: senderEmail)
              .limit(1)
              .get();
      final senderDocRef = senderDocQuery.docs.first.reference;

      await currentUserDocRef.update({
        'incomingRequest': FieldValue.arrayRemove([senderEmail]),
      });

      await senderDocRef.update({
        'outgoingRequest': FieldValue.arrayRemove([currentUserEmail]),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rejected"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
      await _fetchUserData();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: const Color(0xFFefead8),
  body: SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF5F7060)),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              Text(
                'Notifications',
                style: GoogleFonts.ubuntu(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5F7060),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _incomingRequestDetails.isEmpty
              ? Center(
                  child: Text(
                    'No Incoming friend requests.',
                    style: GoogleFonts.ubuntu(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12.0),
                  itemCount: _incomingRequestDetails.length,
                  itemBuilder: (context, index) {
                    final request = _incomingRequestDetails[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: const Color(0xFFFCFAEE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request['userName'] ?? 'Unknown User',
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    request['email'],
                                    style: GoogleFonts.ubuntu(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _acceptRequest(
                                    request['email'],
                                    request['firestoreDocId'],
                                  ),
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _rejectRequest(
                                    request['email'],
                                    request['firestoreDocId'],
                                  ),
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
