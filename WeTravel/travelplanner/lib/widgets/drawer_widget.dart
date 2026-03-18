import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Travel Planner'),
          ),
          ListTile(
            title: const Text('Page 1'),
            onTap: () {
              // Update the state of the app.
              // ...copy paste the navigator.push method here
              //you may navigate to SecondScreen
              Navigator.pop(context);
              Navigator.pushNamed(context, '/page1');
            },
          ),
          ListTile(
            title: const Text('Add Plan'),
            onTap: () {
              // Update the state of the app.
              // ...copy paste here the navigator.push method
              Navigator.pop(context);
              Navigator.pushNamed(context, '/addPlan');
            },
          ),
          ListTile(
            title: const Text('View Profile'),
            onTap: () {
              // Update the state of the app.
              // ...copy paste here the navigator.push method
              Navigator.pop(context);
              Navigator.pushNamed(context, '/viewProfile');
            },
          ),
          ListTile(
            title: const Text('Search'),
            onTap: () {
              // Update the state of the app.
              // ...copy paste here the navigator.push method
              Navigator.pop(context);
              Navigator.pushNamed(context, '/search');
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              context.read<UserAuthProvider>().signOut();
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
