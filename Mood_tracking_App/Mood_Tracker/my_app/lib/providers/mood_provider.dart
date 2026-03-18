import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodProvider with ChangeNotifier {
  final List<MoodEntry> _entries = [];

  List<MoodEntry> get moodEntries => List.unmodifiable(_entries); //to prevent unwanted modifications

  void addEntry(MoodEntry entry) {
    _entries.add(entry);
    notifyListeners(); //to update UI right away
  }

  void deleteEntry(MoodEntry entry) {
    _entries.remove(entry);
    notifyListeners();
  }
}
