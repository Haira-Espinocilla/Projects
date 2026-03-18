import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:travelplanner/screens/edit_plan_page.dart';
import 'package:travelplanner/widgets/qr_widget.dart';
import 'dart:convert';
import '../models/plan_model.dart';
import '../providers/auth_provider.dart';
import '../providers/plan_provider.dart';

class AddPlan extends StatefulWidget {
  final String type;
  final Map<String, dynamic>? planData;
  final String? docId;

  const AddPlan({super.key, required this.type, this.planData, this.docId});

  @override
  State<AddPlan> createState() => _AddPlanState();
}

class _AddPlanState extends State<AddPlan> {
  Plans? existingPlan;
  bool showMore = false;

  final formkey = GlobalKey<FormState>();
  String travelPlanName = "";
  String location = "";
  String email = "";
  String startDate = "";
  String endDate = "";

  String flightNumber = '';
  String flightDeparture = '';
  String flightArrival = '';
  String accomodation = '';
  List<ChecklistItem> checklist = [];
  List<Activity> activities = [];

  String? selectedNotif = "";
  List<DateTime?> _dates = [null, null];

  final TextEditingController _dateController = TextEditingController();

  static final List<String> _dropdownOptions = [
    "1 Day Before",
    "3 Days Before",
    "5 Days Before",
    "7 Days Before",
  ];

  String? _dropdownValue;

  final _locationController = TextEditingController();
  List<dynamic> _placeList = [];

  bool _isSelectingLocation = false;

  @override
  void initState() {
    super.initState();

    if (widget.planData != null) {
      final data = widget.planData!;

      existingPlan = Plans(
        travelPlanName: data['travelPlanName'],
        location: data['location'],
        startDate: data['startDate'],
        endDate: data['endDate'],
        email: data['email'],
        selectedNotif: data['selectedNotif'],

        flightNumber: data['flightNumber'],
        flightDeparture: data['flightDeparture'],
        flightArrival: data['flightArrival'],
        accomodation: data['accomodation'],

        checklist:
            (data['checklist'] as List<dynamic>?)
                ?.map(
                  (item) =>
                      ChecklistItem.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [],

        activities:
            (data['activities'] as List<dynamic>?)
                ?.map((item) => Activity.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
      );

      travelPlanName = existingPlan!.travelPlanName;
      location = existingPlan!.location;
      selectedNotif = existingPlan!.selectedNotif ?? "";
      startDate = existingPlan!.startDate;
      endDate = existingPlan!.endDate;

      flightNumber = existingPlan!.flightNumber ?? '';
      flightDeparture = existingPlan!.flightDeparture ?? '';
      flightArrival = existingPlan!.flightArrival ?? '';
      accomodation = existingPlan!.accomodation ?? '';

      checklist = existingPlan!.checklist;
      activities = existingPlan!.activities;

      _locationController.text = existingPlan!.location;
      _dateController.text = "$startDate - $endDate";
      _dropdownValue =
          _dropdownOptions.contains(existingPlan!.selectedNotif)
              ? existingPlan!.selectedNotif
              : null;
      _dates = [DateTime.tryParse(startDate), DateTime.tryParse(endDate)];
    } else {
      existingPlan = null;
    }

    _locationController.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    if (_isSelectingLocation) {
      return;
    }
    String currentInput = _locationController.text.trim();
    if (currentInput.isEmpty) {
      setState(() {
        _placeList = [];
      });
      return;
    }
    getSuggestion(currentInput);
  }

  void getSuggestion(String input) async {
    String API_KEY = 'MAPBOX_TOKEN_HERE';
        // "pk.eyJ1IjoiZmFieXNzIiwiYSI6ImNtYXl1dXIzZDBjb2sybG9zOHBzZjM4eWEifQ.gL3QhdMdADC6vyfONwRaCA";
    String baseURL = 'https://api.mapbox.com/geocoding/v5/mapbox.places/';
    String request =
        '$baseURL${Uri.encodeComponent(input)}.json?access_token=$API_KEY&types=poi,address,place,locality,region';

    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['features'] != null) {
        setState(() {
          _placeList = responseBody['features'];
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No Location Found")));
        setState(() {
          _placeList = [];
        });
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error")));
      setState(() {
        _placeList = [];
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _updateDateControllerText() {
    if (_dates.isNotEmpty && _dates[0] != null) {
      startDate = DateFormat('yyyy-MM-dd').format(_dates[0]!);
      endDate = '';
      if (_dates.length > 1 && _dates[1] != null) {
        endDate = DateFormat('yyyy-MM-dd').format(_dates[1]!);
      }
      _dateController.text = '$startDate - $endDate';
    } else {
      _dateController.text = '';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? chosenDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: Colors.green,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030, 12, 31),
      ),
      dialogSize: const Size(325, 400),
      value: _dates,
    );

    if (chosenDates != null) {
      setState(() {
        _dates = chosenDates;
        _updateDateControllerText();
      });
    }
  }

  void _submitForm() async {
    if (formkey.currentState!.validate()) {
      String? email = context.read<UserAuthProvider>().user!.email;

      if (email == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User is not signed in")));
        return;
      }

      Plans temp = Plans(
        travelPlanName: travelPlanName,
        location: location,
        email: email,
        selectedNotif: selectedNotif,
        startDate: startDate,
        endDate: endDate,
        flightNumber: flightNumber,
        flightDeparture: flightDeparture,
        flightArrival: flightArrival,
        accomodation: accomodation,
        checklist: checklist,
        activities: activities,
      );

      final provider = context.read<PlanListProvider>();

      if (widget.type == 'edit' && widget.docId != null) {
        await provider.updatePlan(widget.docId!, temp);
        await ScaffoldMessenger.of(
              // ignore: use_build_context_synchronously
              context,
            )
            .showSnackBar(
              const SnackBar(
                content: Text("Plan Updated"),
                duration: Duration(seconds: 1),
              ),
            )
            .closed;
      } else {
        await context.read<PlanListProvider>().addPlan(temp);
        await ScaffoldMessenger.of(
              // ignore: use_build_context_synchronously
              context,
            )
            .showSnackBar(
              const SnackBar(
                content: Text("Plan Added!"),
                duration: Duration(seconds: 1),
              ),
            )
            .closed;
      }
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 234, 216),
        actions: [
          if (widget.type == 'edit' && widget.docId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Plan',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (ctx) => AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text(
                          "Are you sure you want to delete this plan?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  await context.read<PlanListProvider>().deletePlan(
                    widget.docId!,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                }
              },
            ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 239, 234, 216),
      body: _createBody(),
      floatingActionButton: _createFloatingButton(),
    );
  }

  Widget _createBody() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCFAEE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.type == 'edit' ? "Edit Plan" : "Add New Plan",
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5F7060),
                  ),
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
                  children: [
                    if (widget.type == 'edit')
                      ToggleButtons(
                        isSelected: [!showMore, showMore],
                        onPressed: (index) {
                          setState(() {
                            showMore = index == 1;
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        constraints: const BoxConstraints(
                          minHeight: 36,
                          minWidth: 80,
                        ),
                        selectedBorderColor: const Color(0xFF607D69),
                        selectedColor: Colors.white,
                        fillColor: const Color(0xFF607D69),
                        color: const Color(0xFF5F7060),
                        textStyle: GoogleFonts.ubuntu(
                          fontWeight: FontWeight.bold,
                        ),
                        borderColor: const Color(0xFF5F7060),
                        children: const [Text("Overview"), Text("More")],
                      ),
                    if (showMore == true && widget.type == 'edit')
                      _showMoreUI()
                    else
                      Column(
                        children: [
                          // TRAVEL PLAN NAME FIELD
                          _createRequiredTextField(
                            (value) {
                              travelPlanName = value;
                            },
                            "Travel Plan Name",
                            travelPlanName,
                          ),
                          // LOCATION
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: TextField(
                                    controller: _locationController,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      //prefixIcon: Icon(Icons.map),
                                      //suffixIcon: IconButton(icon: Icon(Icons.cancel)),
                                      hintText: "Location",
                                      hintStyle: GoogleFonts.ubuntu(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _placeList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        _placeList[index]["place_name"],
                                      ),
                                      onTap: () {
                                        _isSelectingLocation = true;
                                        final selectedLocation =
                                            _placeList[index]["place_name"];
                                        _locationController.text =
                                            selectedLocation;
                                        setState(() {
                                          location = selectedLocation;
                                          _placeList = [];
                                        });

                                        Future.microtask(() {
                                          _isSelectingLocation = false;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              style: GoogleFonts.ubuntu(),
                              decoration: InputDecoration(
                                hintText: "Select Date",
                                hintStyle: GoogleFonts.ubuntu(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
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
                  children: [
                    //Text("Set Notification"),
                    Padding(
                      padding: const EdgeInsets.all(1),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFFFCFAEE),
                        isExpanded: true,
                        decoration: InputDecoration(
                          // hintText: label,
                          // hintStyle: GoogleFonts.ubuntu(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                        value: _dropdownValue,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectedNotif = value;
                            _dropdownValue = value;
                          });
                        },
                        hint: const Text("Select a notification option"),
                        items:
                            _dropdownOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onSaved: (newValue) {
                          print("Dropdown onSaved method triggered");
                        },
                      ),
                    ),
                    _createPlanButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showMoreUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildNavButton(context, "Flight Details", '/flightdetails'),
        _buildNavButton(context, "Accomodations", '/accomodations'),
        _buildNavButton(context, "Checklist", '/checklist'),
        _buildNavButton(context, "Itinerary", '/itinerary'),
      ],
    );
  }

  Widget _createRequiredTextField(
    Function(String) onChanged,
    String label,
    String initialValue,
  ) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        onChanged: onChanged,
        initialValue: initialValue,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
        style: GoogleFonts.ubuntu(),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: GoogleFonts.ubuntu(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _createPlanButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: 200,
        child: ElevatedButton(
          onPressed: () async {
            _submitForm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF607D69),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text("Save Plan"),
        ),
      ),
    );
  }

  Widget? _createFloatingButton() {
    if (widget.type == 'edit' && widget.docId != null) {
      return FloatingActionButton(
        onPressed:
            () => QRDialog.showQRCode(
              context: context,
              dataToEncode: widget.docId!,
            ),
        backgroundColor: const Color(0xFF607D69),
        foregroundColor: Colors.white,
        tooltip: 'Share Plan',
        child: const Icon(Icons.share),
      );
    } else if (widget.type == 'add') {
      return FloatingActionButton(
        onPressed: () async {
          final scannedDocId = await QRDialog.scanQRCode(context);

          if (scannedDocId != null) {
            final planData = await context
                .read<PlanListProvider>()
                .fetchPlanById(scannedDocId);

            if (planData != null) {
              setState(() {
                travelPlanName = planData['travelPlanName'];
                location = planData['location'];
                selectedNotif = planData['selectedNotif'] ?? '';
                startDate = planData['startDate'];
                endDate = planData['endDate'];

                _locationController.text = location;
                _dropdownValue = selectedNotif;
                _dateController.text = "$startDate - $endDate";
                _dates = [
                  DateTime.tryParse(startDate),
                  DateTime.tryParse(endDate),
                ];
              });
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Plan not found.')));
            }
          }
        },
        backgroundColor: Colors.white,
        tooltip: 'Import Plan',
        child: const Icon(Icons.qr_code_scanner),
      );
    }

    return null;
  }

  Widget _buildNavButton(BuildContext context, String label, String route) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          // Open EditPlan and wait for result
          final result = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EditPlan(
                    type: label,
                    initialFlightNumber: flightNumber,
                    initialFlightDeparture: flightDeparture,
                    initialFlightArrival: flightArrival,
                    initialAccomodation: accomodation,
                    initialChecklist: checklist,
                    initialActivities: activities,
                  ),
            ),
          );
          // Handle result safely
          if (result != null) {
            setState(() {
              if (result.containsKey('flightNumber')) {
                flightNumber = result['flightNumber'] ?? flightNumber;
                flightDeparture = result['flightDeparture'] ?? flightDeparture;
                flightArrival = result['flightArrival'] ?? flightArrival;
              }
              if (result.containsKey('accomodation')) {
                accomodation = result['accomodation'] ?? accomodation;
              }
              if (result.containsKey('checklist')) {
                checklist = List<ChecklistItem>.from(result['checklist']);
              }
              if (result.containsKey('activities')) {
                activities = List<Activity>.from(result['activities']);
              }
            });
          }

          print(result);
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 80),
          backgroundColor: const Color.fromARGB(255, 239, 234, 216),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 18, color: const Color(0xFF5F7060)),
            ),
            Icon(
              Icons.arrow_circle_right_rounded,
              size: 32,
              color: const Color(0xFF5F7060),
            ),
          ],
        ),
      ),
    );
  }
}
