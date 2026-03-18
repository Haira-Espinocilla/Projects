import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelplanner/providers/plan_provider.dart';
import 'package:travelplanner/screens/add_plan_page.dart';
import '../providers/auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? profileBase64;

  User? currentUser;
  String currentUserEmail = '';
  List<String> _currentUserFriends = [];
  List<String> _currentUserOutgoing = [];
  List<String> _currentUserIncoming = [];

  List<Map<String, dynamic>> _users = [];

  late Future<List<Map<String, dynamic>>> _similarUsersFuture;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    currentUserEmail = currentUser?.email ?? '';
    _similarUsersFuture = _fetchSimilarUsers();
    _fetchUserPfp();
  }

  //fetch user's profile picture from firestore
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

  //fetches all users with similar interests and travel styles
  Future<List<Map<String, dynamic>>> _fetchSimilarUsers() async {
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
      final currentInterests = List<String>.from(
        userData['interests'] ?? [],
      ).map((e) => e.toLowerCase()).toList();
      final currentTravelStyles = List<String>.from(
        userData['travelStyles'] ?? [],
      ).map((e) => e.toLowerCase()).toList();

      //FOR INCOMING/OUTGOING/FRIENDS
      final currentUserFriends = List<String>.from(userData['friends'] ?? []);
      final currentUserOutgoing = List<String>.from(
        userData['outgoingRequest'] ?? [],
      );
      final currentUserIncoming = List<String>.from(
        userData['incomingRequest'] ?? [],
      );

      final otherUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', isNotEqualTo: currentUser.email)
          .get();

      final matches = <Map<String, dynamic>>[];

      for (final doc in otherUsers.docs) {
        final data = doc.data();
        final recipientEmail = data['emailAddress'];
        final interests = (data['interests'] is List)
            ? List<String>.from(
                data['interests'],
              ).map((e) => e.toLowerCase()).toList()
            : [data['interests']?.toString().toLowerCase() ?? ''];

        final travelStyles = (data['travelStyles'] is List)
            ? List<String>.from(
                data['travelStyles'],
              ).map((e) => e.toLowerCase()).toList()
            : [data['travelStyles']?.toString().toLowerCase() ?? ''];

        final similarInterests = interests
            .where((i) => currentInterests.contains(i))
            .toList();
        final similarStyles = travelStyles
            .where((s) => currentTravelStyles.contains(s))
            .toList();

        final sharedCount = similarInterests.length + similarStyles.length;

        bool isFriend = currentUserFriends.contains(recipientEmail);
        bool hasSentRequest = currentUserOutgoing.contains(recipientEmail);
        bool hasReceivedRequest = currentUserIncoming.contains(recipientEmail);

        if (sharedCount > 0 ||
            isFriend ||
            hasSentRequest ||
            hasReceivedRequest) {
          matches.add({
            'userName': data['userName'] ?? 'Unknown',
            'sharedCount': sharedCount,
            'firstName': data['firstName'] ?? '',
            'lastName': data['lastName'] ?? '',
            'email': data['emailAddress'],
            'phoneNumber': data['phoneNumber'] ?? '',
            'interests': interests,
            'travelStyles': travelStyles,
            'emailAddress': data['emailAddress'],
            'profileImage': data['profileImage'] ?? '',
            'isPrivate': data['isPrivate'] == true,
            'uid': doc.id,
            'isFriend': isFriend,
            'hasSentRequest': hasSentRequest,
            'hasReceivedRequest': hasReceivedRequest,
          });
        }
      }

      matches.sort((a, b) => b['sharedCount'].compareTo(a['sharedCount']));
      return matches;
    } catch (e) {
      print('Error fetching similar users: $e');
      return [];
    }
  }

  Future<void> _sendFriendRequest(Map<String, dynamic> targetUser) async {
    final targetUserEmail = targetUser['email'];
    final targetUserFirestoreDocId = targetUser['uid'];

    try {
      final senderQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', isEqualTo: currentUserEmail)
          .limit(1)
          .get();
      final senderDocRef = senderQuery.docs.first.reference;

      final recipientDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserFirestoreDocId);

      await senderDocRef.update({
        'outgoingRequest': FieldValue.arrayUnion([targetUserEmail]),
      });

      await recipientDocRef.update({
        'incomingRequest': FieldValue.arrayUnion([currentUserEmail]),
      });

      setState(() {
        _similarUsersFuture = _fetchSimilarUsers();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Request Sent"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
    }
  }

  Future<void> _acceptRequest(
    String senderEmail,
    String senderFirestoreDocId,
  ) async {
    try {
      final currentUserEmail = currentUser!.email!;

      final currentUserDocQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', isEqualTo: currentUserEmail)
          .limit(1)
          .get();
      final currentUserDocRef = currentUserDocQuery.docs.first.reference;

      final senderDocQuery = await FirebaseFirestore.instance
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

      setState(() {
        _similarUsersFuture = _fetchSimilarUsers();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Accepted"), 
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
      await _fetchSimilarUsers();
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

      final currentUserDocQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('emailAddress', isEqualTo: currentUserEmail)
          .limit(1)
          .get();
      final currentUserDocRef = currentUserDocQuery.docs.first.reference;

      final senderDocQuery = await FirebaseFirestore.instance
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

      setState(() {
        _similarUsersFuture = _fetchSimilarUsers();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rejected"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
      await _fetchSimilarUsers();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed"),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2)));
    }
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserAuthProvider>();
    final userData = userProvider.userData;

    if (userData != null) {
      context.read<PlanListProvider>().fetchPlansByEmail(userData.emailAddress);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFefead8),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8.0,
        color: const Color(0xFF5F7060),
        //shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/viewProfile'),
            ),
            IconButton(
              icon: const Icon(Icons.people_alt, color: Colors.white),
              onPressed: () => Navigator.pushNamed(context, '/friends'),
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, '/notification'),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                context.read<UserAuthProvider>().signOut();
                Navigator.pushReplacementNamed(context, '/signIn');
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFD78254),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.add, size: 50),
          onPressed: () async {
            await Navigator.pushNamed(context, '/addPlan');
            // ignore: use_build_context_synchronously
            if (userData != null) context.read<PlanListProvider>().fetchPlansByEmail(userData.emailAddress);

            setState(() {});
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage:
                        (profileBase64 != null && profileBase64!.isNotEmpty)
                        ? MemoryImage(base64Decode(profileBase64!))
                        : const AssetImage('assets/images/default_icon.png')
                              as ImageProvider,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hi, ${userData?.firstName ?? 'Guest'}!',
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5F7060),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Color(0xFF5F7060),
                            size: 30,
                          ),

                          onPressed: () =>
                              Navigator.pushNamed(context, '/search'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/bgImage_23.png',
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      "Let's Travel",
                      style: GoogleFonts.ubuntu(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Upcoming',
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color(0xFF5F7060),
                ),
              ),
              const SizedBox(height: 12),
              Consumer<PlanListProvider>(
                builder: (context, planProvider, _) {
                  return StreamBuilder(
                    stream: planProvider.tracker,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No upcoming travel plans at the moment",
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF5F7060),
                            )
                          ),
                        );
                      }

                      final now = DateTime.now();

                      final upcomingPlans = snapshot.data!.docs.where((doc) {
                        final date = DateTime.tryParse(doc['startDate'] ?? '');
                        return date != null && (date.isAfter(now) || _isSameDay(date, now));
                      }).toList()
                        ..sort((a, b) {
                          final aDate = DateTime.tryParse(a['startDate'] ?? '') ?? DateTime(2100);
                          final bDate = DateTime.tryParse(b['startDate'] ?? '') ?? DateTime(2100);
                          return aDate.compareTo(bDate);
                      });

                      if (upcomingPlans.isEmpty) {
                        return Center(
                          child: Text(
                            "No upcoming travel plans at the moment",
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF5F7060),
                            )
                          ),
                        );
                      }

                      return SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: upcomingPlans.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final docSnapshot = upcomingPlans[index];
                            final planData = docSnapshot.data() as Map<String, dynamic>;
                            final docId = docSnapshot.id;
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPlan(
                                      type: 'edit',
                                      planData: planData,
                                      docId: docId,
                                    )
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                if (userData != null) context.read<PlanListProvider>().fetchPlansByEmail(userData.emailAddress);
                                
                                setState(() {});
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFfcfaee),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: Color(0xFF607D69),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          planData['startDate'],
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 12,
                                            color: const Color(0xFF607D69),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(height: 8),
                                    Text(
                                      planData['travelPlanName'],
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2C3E50),
                                        letterSpacing: 0.5,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Past',
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color(0xFF5F7060),
                ),
              ),
              const SizedBox(height: 12),
              Consumer<PlanListProvider>(
                builder: (context, planProvider, _) {
                  return StreamBuilder(
                    stream: planProvider.tracker,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No past travel plans",
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF5F7060),
                            )
                          ),
                        );
                      }

                      final now = DateTime.now();

                      final pastPlans = snapshot.data!.docs.where((doc) {
                        final date = DateTime.tryParse(doc['startDate'] ?? '');
                        return date != null && (date.isBefore(now) && !_isSameDay(date, now));
                      }).toList()
                        ..sort((a, b) {
                          final aDate = DateTime.tryParse(a['startDate'] ?? '') ?? DateTime(2100);
                          final bDate = DateTime.tryParse(b['startDate'] ?? '') ?? DateTime(2100);
                          return bDate.compareTo(aDate);
                      });

                      if (pastPlans.isEmpty) {
                        return Center(
                          child: Text(
                            "No past plans",
                            style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF5F7060),
                            )
                          ),
                        );
                      }

                      return SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: pastPlans.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final docSnapshot = pastPlans[index];
                            final planData = docSnapshot.data() as Map<String, dynamic>;
                            final docId = docSnapshot.id;
                            return GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddPlan(
                                      type: 'edit',
                                      planData: planData,
                                      docId: docId,
                                    )
                                  ),
                                );
                                // ignore: use_build_context_synchronously
                                if (userData != null) context.read<PlanListProvider>().fetchPlansByEmail(userData.emailAddress);
                                
                                setState(() {});
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFfcfaee),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: Color(0xFF607D69),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          planData['startDate'],
                                          style: GoogleFonts.ubuntu(
                                            fontSize: 12,
                                            color: const Color(0xFF607D69),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    const SizedBox(height: 8),
                                    Text(
                                      planData['travelPlanName'],
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2C3E50),
                                        letterSpacing: 0.5,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Find Similar People',
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: const Color(0xFF5F7060),
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _similarUsersFuture,
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
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final user = users[index];

                        final bool isFriend = user['isFriend'] ?? false;
                        final bool hasSentRequest =
                            user['hasSentRequest'] ?? false;
                        final bool hasReceivedRequest =
                            user['hasReceivedRequest'] ?? false;
                        final String otherUserEmail = user['email'] as String;

                        String buttonText = '+ ADD FRIEND';
                        Color borderColor = const Color(0xFF607D69);
                        Color textColor = const Color(0xFF607D69);
                        VoidCallback? onTapFunction;

                        if (otherUserEmail == currentUserEmail) {
                          buttonText = 'YOUR PROFILE';
                          borderColor = Colors.grey;
                          textColor = Colors.grey;
                          onTapFunction = null;
                        } else if (isFriend) {
                          buttonText = 'FRIENDS';
                          borderColor = Colors.green;
                          textColor = Colors.green;
                          onTapFunction = null;
                        } else if (hasSentRequest) {
                          buttonText = 'REQUEST SENT';
                          borderColor = Colors.grey;
                          textColor = Colors.grey;
                          onTapFunction = null;
                        } else if (hasReceivedRequest) {
                          buttonText = 'ACCEPT';
                          borderColor = Colors.grey;
                          textColor = Colors.grey;
                          onTapFunction = () async {
                            _acceptRequest(user['email'], user['uid']);
                          };
                        } else {
                          buttonText = '+ ADD FRIEND';
                          borderColor = Colors.grey;
                          textColor = Colors.grey;
                          onTapFunction = () async {
                            _sendFriendRequest(user);
                          };
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/otherProfile',
                              arguments: user,
                            );
                          },
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFfcfaee),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      (user['profileImage'] != null &&
                                          user['profileImage']
                                              .toString()
                                              .isNotEmpty)
                                      ? MemoryImage(
                                          base64Decode(user['profileImage']),
                                        )
                                      : const AssetImage(
                                              'assets/images/default_icon.png',
                                            )
                                            as ImageProvider,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  user['userName'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5F7060),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onTap: onTapFunction,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF607D69),
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      buttonText,
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 11,
                                        color: const Color(0xFF607D69),
                                        fontWeight: FontWeight.bold,
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}