import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/formpage_screen.dart';
import 'screens/entriespage_screen.dart';
import 'providers/mood_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodProvider(), //provider
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),

      //initial route
      initialRoute: '/',

      //named routes
      routes: {
        '/': (context) => const EntriesPageScreen(), //to entries page screen
        '/add-entry': (context) => const FormPageScreen(), //to form page screen
      },
    );
  }
}
