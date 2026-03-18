import 'package:flutter/material.dart';
import '../screens/entriespage_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4C3A74), Color(0xFFEAE6F2)], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/frieren.jpg"), 
                ),
                const SizedBox(height: 10),
                Text(
                  "Mood Tracker",
                  style: GoogleFonts.pacifico(fontSize: 22, color: Colors.white),
                ),
              ],
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.add_circle, color: Color(0xFF8DB6D0)), 
            title: Text(
              "Add an Entry",
              style: GoogleFonts.lato(fontSize: 18, color: Color(0xFF6B728E)), 
            ),
            onTap: () {
              Navigator.pushNamed(context, '/add-entry');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list, color: Color(0xFF7D6B91)), 
            title: Text(
              "Mood Entries",
              style: GoogleFonts.lato(fontSize: 18, color: Color(0xFF6B728E)),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EntriesPageScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
