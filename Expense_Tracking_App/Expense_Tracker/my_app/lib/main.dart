import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/signup_page.dart';
import 'firebase_options.dart';
import 'providers/todo_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => TodoListProvider())),
        ChangeNotifierProvider(create: ((context) => UserAuthProvider())),
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
      title: 'Expense Tracker',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/signUp': (context) => const SignUp(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
