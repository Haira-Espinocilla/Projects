import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travelplanner/models/plan_model.dart';

class EditPlan extends StatefulWidget {
  final String type;
  final String? initialFlightNumber;
  final String? initialFlightDeparture;
  final String? initialFlightArrival;
  final String? initialAccomodation;
  final List<ChecklistItem>? initialChecklist;
  final List<Activity>? initialActivities;

  const EditPlan({
    super.key,
    required this.type,
    this.initialFlightNumber,
    this.initialFlightDeparture,
    this.initialFlightArrival,
    this.initialAccomodation,
    this.initialChecklist,
    this.initialActivities,
  });

  @override
  State<EditPlan> createState() => _EditPlansState();
}

class _EditPlansState extends State<EditPlan> {
  final flightDetailsFormKey = GlobalKey<FormState>();
  final accomodationsFormKey = GlobalKey<FormState>();
  final checklistFormKey = GlobalKey<FormState>();
  final itineraryFormKey = GlobalKey<FormState>();

  late String flightNumber;
  late String flightDeparture;
  late String flightArrival;
  late String accomodation;
  late List<ChecklistItem> _checklist;
  late List<Activity> _activities;

  @override
  void initState() {
    super.initState();
    flightNumber = widget.initialFlightNumber ?? '';
    flightDeparture = widget.initialFlightDeparture ?? '';
    flightArrival = widget.initialFlightArrival ?? '';
    accomodation = widget.initialAccomodation ?? '';
    _checklist = List.from(widget.initialChecklist ?? []);
    _activities = List.from(widget.initialActivities ?? []);
  }

  void _saveAndPop() {
    Navigator.pop(context, {
      'flightNumber': flightNumber,
      'flightDeparture': flightDeparture,
      'flightArrival': flightArrival,
      'accomodation': accomodation,
      'checklist': _checklist,
      'activities': _activities,
    });
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAEE),
        title: Text(
          widget.type,
          style: GoogleFonts.ubuntu(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5F7060),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5F7060)),
        actions: [
          IconButton(
            onPressed: _saveAndPop,
            icon: const Icon(Icons.check, color: Color(0xFF5F7060)),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFefead8),
      body: _buildBodyByType(widget.type),
    );
  }

  Widget _buildBodyByType(String type) {
    switch (type) {
      case 'Flight Details':
        return _createFlightDetails();
      case 'Accomodations':
        return _createAccomodations();
      case 'Checklist':
        return _createChecklist();
      case 'Itinerary':
        return _createItinerary();
      default:
        return Center(child: Text('Unknown type'));
    }
  }

  Widget _createFlightDetails() {
    return _buildSection(
      formKey: flightDetailsFormKey,
      children: [
        _buildFlightRow(
          label: "Flight Number",
          onChanged: (value) => flightNumber = value,
          initialValue: flightNumber,
        ),
        _buildFlightRow(
          label: "Departure",
          onChanged: (value) => flightDeparture = value,
          initialValue: flightDeparture,
        ),
        _buildFlightRow(
          label: "Arrival",
          onChanged: (value) => flightArrival = value,
          initialValue: flightArrival,
        ),
      ],
    );
  }

  Widget _createAccomodations() {
    return _buildSection(
      formKey: accomodationsFormKey,
      title: "Where will you stay",
      children: [
        Text(
          "Set Accomodation",
          style: GoogleFonts.ubuntu(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5F7060),
          ),
        ),
        _createTextField((value) => accomodation = value, accomodation),
      ],
    );
  }

  Widget _buildSection({
    required GlobalKey<FormState> formKey,
    String? title,
    required List<Widget> children,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    title,
                    style: GoogleFonts.ubuntu(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5F7060),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFAEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: children),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightRow({
    required String label,
    required Function(String) onChanged,
    required String initialValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5F7060),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width:
                MediaQuery.of(context).size.width * 0.4, 
            child: _createTextField(onChanged, initialValue),
          ),
        ],
      ),
    );
  }

  Widget _createChecklist() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: checklistFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Checklist",
                style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5F7060),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFAEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._checklist.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.checked,
                              onChanged: (value) {
                                setState(() {
                                  item.checked = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: item.name,
                                onChanged: (value) {
                                  setState(() {
                                    item.name = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Checklist Item ${index + 1}",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _checklist.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    Center(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _checklist.add(
                              ChecklistItem(checked: false, name: ''),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFCFAEE),
                          foregroundColor: const Color(0xFF5F7060),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "+ Add Checklist",
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF5F7060),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createItinerary() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: itineraryFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "My Activities",
                style: GoogleFonts.ubuntu(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5F7060),
                ),
              ),
              const SizedBox(height: 24),
              _activities.isEmpty
                  ? const SizedBox()
                  : Column(
                    children:
                        _activities.asMap().entries.map((entry) {
                          int index = entry.key;
                          Activity activity = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFCFAEE),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location",
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF5F7060),
                                    ),
                                  ),
                                  _createTextField(
                                    (value) => activity.location = value,
                                    activity.location,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Time",
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF5F7060),
                                    ),
                                  ),
                                  _createTextField(
                                    (value) => activity.time = value,
                                    activity.time,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Description",
                                    style: GoogleFonts.ubuntu(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF5F7060),
                                    ),
                                  ),
                                  _createTextField(
                                    (value) => activity.description = value,
                                    activity.description,
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                  ),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _activities.add(
                        Activity(location: '', time: '', description: ''),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 239, 234, 216),
                    foregroundColor: const Color(0xFF5F7060),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "+ Add Activity",
                    style: GoogleFonts.ubuntu(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5F7060),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTextField(
    Function(String) onChanged,
    String initialValue, {
    int maxLines = 1,
  }) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: initialValue,
      maxLines: maxLines,
      style: GoogleFonts.ubuntu(color: const Color(0xFF5F7060)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF5F7060)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF607D69), width: 2),
        ),
      ),
    );
  }
} 
