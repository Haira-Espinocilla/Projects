// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:travelplanner/providers/plan_provider.dart';
// import 'package:travelplanner/widgets/qr_widget.dart';
// import '../providers/auth_provider.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   Future<List<Map<String, dynamic>>> _fetchSimilarUsers() async {
//     try {
//       final currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser == null) return [];

//       final userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('emailAddress', isEqualTo: currentUser.email)
//           .limit(1)
//           .get();

//       if (userSnapshot.docs.isEmpty) return [];

//       final userData = userSnapshot.docs.first.data();
//       final currentInterests = List<String>.from(userData['interests'] ?? []).map((e) => e.toLowerCase()).toList();
//       final currentTravelStyles = List<String>.from(userData['travelStyles'] ?? []).map((e) => e.toLowerCase()).toList();

//       final otherUsers = await FirebaseFirestore.instance
//           .collection('users')
//           .where('emailAddress', isNotEqualTo: currentUser.email)
//           .get();

//       final matches = <Map<String, dynamic>>[];

//       for (final doc in otherUsers.docs) {
//         final data = doc.data();
//         final interests = (data['interests'] is List)
//             ? List<String>.from(data['interests']).map((e) => e.toLowerCase()).toList()
//             : [data['interests']?.toString().toLowerCase() ?? ''];

//         final travelStyles = (data['travelStyles'] is List)
//             ? List<String>.from(data['travelStyles']).map((e) => e.toLowerCase()).toList()
//             : [data['travelStyles']?.toString().toLowerCase() ?? ''];

//         final similarInterests = interests.where((i) => currentInterests.contains(i)).toList();
//         final similarStyles = travelStyles.where((s) => currentTravelStyles.contains(s)).toList();

//         final sharedCount = similarInterests.length + similarStyles.length;

//         if (sharedCount > 0) {
//           matches.add({
//             'userName': data['userName']?.toString().trim().isNotEmpty == true
//                 ? data['userName'].toString().trim()
//                 : data['emailAddress'] ?? 'Unknown',
//             'sharedCount': sharedCount,
//           });
//         }
//       }

//       matches.sort((a, b) => b['sharedCount'].compareTo(a['sharedCount']));
//       return matches;
//     } catch (e) {
//       print('Error fetching similar users: $e');
//       return [];
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.watch<UserAuthProvider>();
//     final userData = userProvider.userData;

//     if (userData != null) {
//       context.read<PlanListProvider>().fetchPlansByEmail(userData.emailAddress);
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFefead8),
//       bottomNavigationBar: BottomAppBar(
//         notchMargin: 8.0,
//         color: const Color(0xFF5F7060),
//         //shape: const CircularNotchedRectangle(),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.person, color: Colors.white),
//               onPressed: () => Navigator.pushNamed(context, '/viewProfile'),
//             ),
//             const SizedBox(width: 48),
//             IconButton(
//               icon: const Icon(Icons.logout, color: Colors.white),
//               onPressed: () {
//                 context.read<UserAuthProvider>().signOut();
//                 Navigator.pushReplacementNamed(context, '/signIn');
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: SizedBox(
//         width: 80,
//         height: 80,
//         child: FloatingActionButton(
//           backgroundColor: const Color(0xFFD78254),
//           elevation: 4,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: const Icon(Icons.add, size: 50),
//           onPressed: () => Navigator.pushReplacementNamed(context, '/addPlan'),
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   const CircleAvatar(
//                     radius: 24,
//                     backgroundImage: AssetImage('assets/images/bgImage_23.png'),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Hi, ${userData?.firstName ?? 'Guest'}!',
//                           style: GoogleFonts.ubuntu(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF5F7060),
//                           ),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.search, color: Color(0xFF5F7060), size: 30),
//                           onPressed: () => Navigator.pushNamed(context, '/search'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/bgImage_23.png',
//                       width: double.infinity,
//                       height: 180,
//                       fit: BoxFit.cover,
//                     ),
//                     Text(
//                       "Let's Travel",
//                       style: GoogleFonts.ubuntu(
//                         fontSize: 28,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Upcoming',
//                 style: GoogleFonts.ubuntu(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: const Color(0xFF5F7060),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Consumer<PlanListProvider>(
//                 builder: (context, planProvider, _) {
//                   return StreamBuilder(
//                     stream: planProvider.tracker,
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (snapshot.hasError) {
//                         return Center(child: Text("Error: ${snapshot.error}"));
//                       }
//                       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                         return const Center(child: Text("No travel plans at the moment"));
//                       }
//                       final plans = snapshot.data!.docs;
//                       return SizedBox(
//                         height: 140,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: plans.length,
//                           separatorBuilder: (_, __) => const SizedBox(width: 12),
//                           itemBuilder: (context, index) {
//                             final planData = plans[index].data() as Map<String, dynamic>;
//                             final docId = plans[index].id;
//                             return GestureDetector(
//                               onTap: () => QRDialog.show(context: context, dataToEncode: docId),
//                               child: Container(
//                                 width: 120,
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.2),
//                                       blurRadius: 4,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(planData['startDate'], style: const TextStyle(fontSize: 12)),
//                                     const Spacer(),
//                                     Image.asset('assets/images/bgImage_23.png', height: 32),
//                                     const SizedBox(height: 4),
//                                     Text(planData['travelPlanName'], style: GoogleFonts.ubuntu()),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Find Similar People',
//                 style: GoogleFonts.ubuntu(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                   color: const Color(0xFF5F7060),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               FutureBuilder<List<Map<String, dynamic>>>(
//                 future: _fetchSimilarUsers(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error loading matches', style: TextStyle(color: Colors.red)));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No Match Found', style: TextStyle(color: Colors.grey)));
//                   }
//                   final users = snapshot.data!;
//                   return SizedBox(
//                     height: 180,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: users.length,
//                       separatorBuilder: (_, __) => const SizedBox(width: 12),
//                       itemBuilder: (context, index) {
//                         final user = users[index];
//                         return Container(
//                           width: 140,
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFfcfaee),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const CircleAvatar(
//                                 radius: 35,
//                                 backgroundImage: AssetImage('assets/images/bgImage_23.png'),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 user['userName'],
//                                 textAlign: TextAlign.center,
//                                 style: GoogleFonts.ubuntu(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF5F7060),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: const Color(0xFF607D69)),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child: Text(
//                                   '+ ADD FRIEND',
//                                   style: GoogleFonts.ubuntu(
//                                     fontSize: 11,
//                                     color: const Color(0xFF607D69),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//     var userDetail = context.watch<UserAuthProvider>().user;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text("${widget.title} | Logged-In User: ${userDetail?.email}"),
//         //This is just a checker to see if it is signed in on the correct user
//       ),
//       drawer: MyDrawer(),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('You have pushed the button this many times:'),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: _incrementCounter,
//             tooltip: 'Increment',
//             child: const Icon(Icons.add),
//           ), // This trailing comma makes auto-formatting nicer for build methods.
//           FloatingActionButton(
//             heroTag: "btn2",
//             onPressed: () {
//               context.read<UserAuthProvider>().signOut();
//               Navigator.pop(context);
//               Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//             },
//             tooltip: 'Sign-out',
//             child: const Icon(Icons.access_time_filled),
//           ), // SIGN OUT BUTTON BESIDE THE INCREMENT BUTTON
//         ],
//       ),
//     );
//   }
// }
