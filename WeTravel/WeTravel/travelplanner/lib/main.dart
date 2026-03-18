import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelplanner/providers/plan_provider.dart';
import 'package:travelplanner/screens/friends_page.dart';
import 'package:travelplanner/screens/home_page.dart';
import 'package:travelplanner/screens/notif_page.dart';
import 'package:travelplanner/screens/otherProfile_page.dart';

import 'firebase_options.dart';
import '../../providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'screens/add_plan_page.dart';
import 'screens/profile_page.dart';
import 'screens/search_page.dart';
import 'screens/signup_page.dart';
import 'screens/edit_plan_page.dart';
import 'screens/signin_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
        ChangeNotifierProvider(create: ((context) => UserListProvider())),
        ChangeNotifierProvider(create: ((context) => PlanListProvider())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WeTravel',
      initialRoute: '/signIn',
      routes: {
        //all page routes are placed here
        '/': (context) => const HomePage(),
        '/signIn': (context) => const SignIn(),
        '/signUp': (context) => const SignUp(),
        '/addPlan': (context) => const AddPlan(type: 'add'),
        '/viewProfile': (context) => const ProfilePage(),
        '/search': (context) => const SearchPage(),
        '/flightdetails': (context) => const EditPlan(type: 'Flight Details'),
        '/accomodations': (context) => const EditPlan(type: 'Accomodations'),
        '/checklist': (context) => const EditPlan(type: 'Checklist'),
        '/itinerary': (context) => const EditPlan(type: 'Itinerary'),
        '/notification': (context) => const NotifPage(),
        '/otherProfile': (context) => const OtherProfilePage(),
        '/friends': (context) => const FriendsPage(),
      },
      theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
