import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:travelplanner/providers/auth_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;
  bool _noResults = false;

  User? currentUser;
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    currentUserEmail = currentUser?.email ?? '';
    _fetchSimilarUsers();
  }

  Future<Map<String, dynamic>?> _getCurrentUserData() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('emailAddress', isEqualTo: currentUserEmail)
            .limit(1)
            .get();
    return snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null;
  }

  Future<void> _fetchSimilarUsers([String? query]) async {
    setState(() => _loading = true);
    try {
      if (currentUser == null) return;
      final userData = await _getCurrentUserData();
      if (userData == null) return;

      final currentInterests =
          List<String>.from(
            userData['interests'] ?? [],
          ).map((e) => e.toLowerCase()).toList();
      final currentTravelStyles =
          List<String>.from(
            userData['travelStyles'] ?? [],
          ).map((e) => e.toLowerCase()).toList();
      final currentUserFriends = List<String>.from(userData['friends'] ?? []);
      final currentUserOutgoing = List<String>.from(
        userData['outgoingRequest'] ?? [],
      );
      final currentUserIncoming = List<String>.from(
        userData['incomingRequest'] ?? [],
      );

      final usersRef = FirebaseFirestore.instance.collection('users');
      final otherUsers =
          query != null && query.trim().isNotEmpty
              ? await usersRef
                  .where('userName', isGreaterThanOrEqualTo: query)
                  .where('userName', isLessThanOrEqualTo: query + '\uf8ff')
                  .get()
              : await usersRef
                  .where('emailAddress', isNotEqualTo: currentUserEmail)
                  .get();

      final matches = <Map<String, dynamic>>[];

      for (final doc in otherUsers.docs) {
        final data = doc.data();
        if (data['emailAddress'] == currentUserEmail) continue;

        final recipientEmail = data['emailAddress'];
        final interests =
            List<String>.from(
              data['interests'] ?? [],
            ).map((e) => e.toLowerCase()).toList();
        final travelStyles =
            List<String>.from(
              data['travelStyles'] ?? [],
            ).map((e) => e.toLowerCase()).toList();
        final similarInterests =
            interests.where(currentInterests.contains).toList();
        final similarStyles =
            travelStyles.where(currentTravelStyles.contains).toList();

        final sharedCount = similarInterests.length + similarStyles.length;
        final isFriend = currentUserFriends.contains(recipientEmail);
        final hasSentRequest = currentUserOutgoing.contains(recipientEmail);
        final hasReceivedRequest = currentUserIncoming.contains(recipientEmail);

        if (sharedCount > 0 ||
            isFriend ||
            hasSentRequest ||
            hasReceivedRequest ||
            query != null) {
          matches.add({
            'userName': data['userName'] ?? 'Unknown',
            'firstName': data['firstName'] ?? '',
            'lastName': data['lastName'] ?? '',
            'phoneNumber': data['phoneNumber'] ?? '',
            'interests': interests,
            'travelStyles': travelStyles,
            'emailAddress': data['emailAddress'],
            'profileImage': data['profileImage'] ?? '',
            'coverImage': data['coverImage'] ?? '',
            'isPrivate': data['isPrivate'] == true,
            'sharedCount': sharedCount,
            'uid': doc.id,
            'isFriend': isFriend,
            'hasSentRequest': hasSentRequest,
            'hasReceivedRequest': hasReceivedRequest,
          });
        }
      }

      matches.sort((a, b) => b['sharedCount'].compareTo(a['sharedCount']));
      setState(() {
        _results = matches;
        _loading = false;
      });
    } catch (e) {
      print('Error fetching users: $e');
      setState(() => _loading = false);
    }
  }

  void _goToOtherProfile(BuildContext context, Map<String, dynamic> user) {
    Navigator.pushNamed(context, '/otherProfile', arguments: user);
  }

  Future<void> _sendFriendRequest(Map<String, dynamic> targetUser) async {
    final recipientEmail = targetUser['emailAddress'];
    final docId = targetUser['uid'];
    try {
      final senderQuery =
          await FirebaseFirestore.instance
              .collection('users')
              .where('emailAddress', isEqualTo: currentUserEmail)
              .limit(1)
              .get();
      final senderRef = senderQuery.docs.first.reference;
      final recipientRef = FirebaseFirestore.instance
          .collection('users')
          .doc(docId);

      await senderRef.update({
        'outgoingRequest': FieldValue.arrayUnion([recipientEmail]),
      });
      await recipientRef.update({
        'incomingRequest': FieldValue.arrayUnion([currentUserEmail]),
      });

      await _fetchSimilarUsers();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Request Sent')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed')));
    }
  }

  Future<void> _acceptRequest(String email, String docId) async {
    try {
      final currentUserRef =
          (await FirebaseFirestore.instance
                  .collection('users')
                  .where('emailAddress', isEqualTo: currentUserEmail)
                  .limit(1)
                  .get())
              .docs
              .first
              .reference;

      final senderRef =
          (await FirebaseFirestore.instance
                  .collection('users')
                  .where('emailAddress', isEqualTo: email)
                  .limit(1)
                  .get())
              .docs
              .first
              .reference;

      await currentUserRef.update({
        'incomingRequest': FieldValue.arrayRemove([email]),
        'friends': FieldValue.arrayUnion([email]),
      });

      await senderRef.update({
        'outgoingRequest': FieldValue.arrayRemove([currentUserEmail]),
        'friends': FieldValue.arrayUnion([currentUserEmail]),
      });

      await _fetchSimilarUsers();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Accepted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAEE),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF607D69)),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Color(0xFF607D69)),
                decoration: const InputDecoration(
                  hintText: 'Search username',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: (query) => _fetchSimilarUsers(query),
              ),
            ),
          ],
        ),
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _results.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final user = _results[index];
                  final otherEmail = user['emailAddress'] ?? '';
                  final isFriend = user['isFriend'] ?? false;
                  final hasSent = user['hasSentRequest'] ?? false;
                  final hasReceived = user['hasReceivedRequest'] ?? false;

                  String label = '+ ADD FRIEND';
                  Color border = const Color(0xFF607D69);
                  VoidCallback? action;

                  if (otherEmail == currentUserEmail) {
                    label = 'YOUR PROFILE';
                    border = Colors.grey;
                  } else if (isFriend) {
                    label = 'FRIENDS';
                    border = Colors.green;
                  } else if (hasSent) {
                    label = 'REQUEST SENT';
                    border = Colors.grey;
                  } else if (hasReceived) {
                    label = 'ACCEPT';
                    action =
                        () => _acceptRequest(user['emailAddress'], user['uid']);
                  } else {
                    action = () => _sendFriendRequest(user);
                  }

                  return GestureDetector(
                    onTap: () => _goToOtherProfile(context, user),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCFAEE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user['userName'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          GestureDetector(
                            onTap: action,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: border),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: border,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
