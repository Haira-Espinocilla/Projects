//form page screen
//this screen displays the mood tracker form
// - allows users to input and submit mood entries
// - has drawer for navigation

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mood_provider.dart';
import '../models/mood_entry.dart';
import '../common/form_field.dart';
import '../common/drawer_widget.dart';

class FormPageScreen extends StatelessWidget {
  const FormPageScreen({super.key});

  //adds a new entry to the provider
  //makes sure that the new entry appears in the mood entries list
  void _submitMood(BuildContext context, MoodEntry entry) {
    final moodProvider = Provider.of<MoodProvider>(context, listen: false);
    moodProvider.addEntry(entry); //to make sure an entry is added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(), //drawer
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), //hamburger menu
            onPressed: () {
              Scaffold.of(context).openDrawer(); //open drawer
            },
          ),
        ),
      ),
      //so MoodTracker can know what to do with the data
      body: MoodTracker(onSubmit: (entry) => _submitMood(context, entry)),
    );
  }
}
