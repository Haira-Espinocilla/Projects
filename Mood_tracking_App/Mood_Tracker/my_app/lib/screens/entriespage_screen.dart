//mood entries page screen
//this screen displays all recorded mood entries
// - if no entries, display "Add Entry"
// - display user entries
// - user can tap on entry to view more info
// - user can delete by clicking the trash icon

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/mood_provider.dart';
import 'details_screen.dart';
import '../common/drawer_widget.dart';

class EntriesPageScreen extends StatelessWidget {
  const EntriesPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE6F2),
      appBar: AppBar(
        title: Text(
          "Mood Entries",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4C3A74),
        foregroundColor: Colors.white,
      ),
      drawer: const DrawerWidget(), //drawer
      body: Consumer<MoodProvider>(
        builder: (context, moodProvider, child) {
          final moodEntries = moodProvider.moodEntries;

          return moodEntries.isEmpty
              ? _buildEmptyState(context) //show empty state if there's no entries existing
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: moodEntries.length,
                  itemBuilder: (context, index) {
                    final entry = moodEntries[index];

                    //to convert date and time to a much more readable format
                    String formattedDateTime =
                        DateFormat('MMM dd, yyyy hh:mm a').format(entry.moodTimestamp);

                    return Card(
                      elevation: 4,
                      color: const Color(0xFFD9D3E0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF7D6B91),
                          child: const Icon(Icons.emoji_emotions, color: Colors.white),
                        ),
                        title: Text(
                          entry.moodOwnerName ?? "Unknown",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        subtitle: Text(
                          "Date: $formattedDateTime", //to format date and time
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent), //delete button
                              onPressed: () {
                                moodProvider.deleteEntry(entry);
                              },
                            ),
                            const Icon(Icons.arrow_forward_ios, color: Color(0xFF4C3A74)),
                          ],
                        ),
                        //go to details page
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(entry: entry),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

//display a placeholder if there are no mood entries yet
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Image.asset("assets/images/divider.png", height: 150),
          ),
          const SizedBox(height: 25),
          Text(
            "No entries yet. Try adding some!",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B728E),
              shadows: [
                Shadow(color: Colors.black, blurRadius: 2, offset: const Offset(1, 1)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/add-entry'),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              "Add Entry",
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8DB6D0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
