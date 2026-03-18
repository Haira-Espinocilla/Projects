//details screen
//this screen displays the details of a mood entry

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/mood_entry.dart';

class DetailsScreen extends StatelessWidget {
  //the mood entry passed from the previous screen
  final MoodEntry entry;

  const DetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    //to make the date and time much more reliable
    String formattedDateTime = DateFormat('MMM dd, yyyy hh:mm a').format(entry.moodTimestamp);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mood Entry Details",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF4C3A74),
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAE6F2), Color(0xFFD9D3E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Name
                  Text(
                    entry.moodOwnerName ?? "Unknown",
                    style: GoogleFonts.pacifico(fontSize: 24, color: Color(0xFF4C3A74)),
                  ),
                  //if there is nickname
                  if (entry.moodOwnerNickname?.isNotEmpty == true)
                    Text(
                      "Nickname: ${entry.moodOwnerNickname}",
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                    ),
                  const Divider(thickness: 1.5),

                  //to display mood infos
                  _buildDetailRow(Icons.mood, "Mood", entry.moodEmotion ?? "Unknown"),
                  _buildDetailRow(Icons.whatshot, "Intensity", "${entry.moodIntensity}/10"),
                  _buildDetailRow(Icons.cloud, "Weather", entry.moodWeather ?? "Unknown"),
                  _buildDetailRow(Icons.fitness_center, "Exercised", entry.didExercise == true ? "Yes" : "No"),
                  
                  const SizedBox(height: 10),
                  Text(
                    "Date: $formattedDateTime",
                    style: GoogleFonts.poppins(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//to build a row to display an icon, a label, and a value
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF8DB6D0)),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
