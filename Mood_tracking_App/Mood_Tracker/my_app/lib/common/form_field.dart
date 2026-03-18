import 'package:flutter/material.dart';
import '../models/mood_entry.dart';

class MoodTracker extends StatefulWidget {
  final Function(MoodEntry) onSubmit;

  const MoodTracker({super.key, required this.onSubmit});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  // to validate form inputs
  final _formKey = GlobalKey<FormState>();

  // to manage text field inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // to hold form data
  String? _selectedMood = "Joy";
  double _moodIntensity = 5.0;
  String? _selectedWeather = "Sunny";
  bool _exercisedToday = true;
  MoodEntry? _moodEntry;


  static final List<String> _weatherOptions = [
    "Sunny",
    "Rainy",
    "Stormy",
    "Hailing",
    "Snowy",
    "Cloudy",
    "Foggy",
    "Partly Cloudy"
  ];

  static final List<String> _moodOptions = [
    "Joy",
    "Sadness",
    "Disgust",
    "Fear",
    "Anger",
    "Anxiety",
    "Embarrassment",
    "Envy"
  ];

  @override
  void dispose() {
    // to free resources
    _nameController.dispose();
    _nicknameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  //to submit the form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
      _moodEntry = MoodEntry(
        moodOwnerName: _nameController.text,
        moodOwnerNickname: _nicknameController.text,
        moodOwnerAge: _ageController.text,
        moodEmotion: _selectedMood ?? "Joy",
        moodIntensity: _moodIntensity,
        moodWeather: _selectedWeather ?? "Sunny",
        didExercise: _exercisedToday,
      );
    });

      widget.onSubmit(_moodEntry!); // to make sure it won't redirect to Mood Entries right away

      String summary = "Name: ${_nameController.text}\n"
          "${_nicknameController.text.isNotEmpty ? "Nickname: ${_nicknameController.text}\n" : ""}"
          "Age: ${_ageController.text}\n"
          "Exercised Today? ${_exercisedToday ? "Yes" : "No"}\n"
          "Mood: $_selectedMood\n"
          "Mood Intensity: ${_moodIntensity.toInt()}/10\n"
          "Weather: $_selectedWeather";

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Mood Tracker Summary"),
            content: Text(summary),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); //to close dialog
                  _resetForm(); //to reset the form
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // to reset the form into its default values
  void _resetForm() {
    setState(() {
      _nameController.clear();
      _nicknameController.clear();
      _ageController.clear();
      _selectedMood = "Joy";
      _moodIntensity = 5.0;
      _selectedWeather = "Sunny";
      _exercisedToday = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Name
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
                controller:
                    _nameController, //links to _nameController to store input text
                validator: (value) => value!.isEmpty
                    ? "Please enter your name"
                    : null, //if value is empty, return message
              ),
            ),
            //Nickname
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nickname",
                ),
                controller: _nicknameController,
              ),
            ),
            //row for age and the switch
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Age",
                      ),
                      keyboardType: TextInputType.number,
                      controller: _ageController,
                      validator: (value) {
                        //if age is null
                        if (value == null || value.isEmpty) {
                          return "Please enter your age";
                        }
                        //if age is not valid
                        if (!RegExp(r'^[1-9]\d*$').hasMatch(value)) {
                          return "Please enter a valid age";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                // Switch
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          // to make the label also clickable
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _exercisedToday = !_exercisedToday;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text("Exercised\nToday?"),
                            ),
                          ),
                        ),
                        //the actual switch
                        Switch(
                          value: _exercisedToday,
                          onChanged: (value) {
                            setState(() {
                              _exercisedToday = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Select Your Mood"),
            // grid view for the radio
            GridView.builder(
              shrinkWrap:
                  true, //makes sure that Grid View only takes necessary space
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.0,
              ),
              itemCount: _moodOptions.length, //how many items to display
              itemBuilder: (context, index) {
                return RadioListTile(
                  title: Text(_moodOptions[index]),
                  value: _moodOptions[index], //each button represents a mood
                  groupValue: _selectedMood, //select one button at a time
                  onChanged: (value) {
                    setState(() {
                      _selectedMood =
                          value.toString(); //to make sure it's stored as String
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            //slider for mood intensity
            Text("Mood Intensity: ${_moodIntensity.toInt()}"),
            Slider(
              value: _moodIntensity,
              min: 1,
              max: 10,
              divisions: 9,
              label: _moodIntensity
                  .toInt()
                  .toString(), //not decimal, convert int to string
              onChanged: (value) {
                setState(() {
                  _moodIntensity = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // dropdown for selecting weather
            const Text("Select Weather"),
            DropdownButtonFormField<String>(
              value: _selectedWeather,
              items: _weatherOptions.map((weather) {
                return DropdownMenuItem(value: weather, child: Text(weather));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWeather = value;
                });
              },
            ),
            const SizedBox(height: 20),
            // row for save and reset buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _submitForm, child: Text('Save')),
                ElevatedButton(onPressed: _resetForm, child: Text('Reset')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
