import 'dart:convert';

class Plans {
  String? id;
  String travelPlanName;
  String location;
  String startDate;
  String endDate;
  String email;
  String? selectedNotif;

  String? flightNumber;
  String? flightDeparture;
  String? flightArrival;

  String? accomodation;

  List<ChecklistItem> checklist;
  List<Activity> activities;

  Plans({
    this.id,
    required this.travelPlanName,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.email,
    this.selectedNotif,

    this.flightNumber,
    this.flightDeparture,
    this.flightArrival,

    this.accomodation,

    this.activities = const [],
    this.checklist = const []
  });

  // Factory constructor to instantiate object from json format
  factory Plans.fromJson(Map<String, dynamic> json) {
    return Plans(
      id: json['id'],
      travelPlanName: json['travelPlanName'],
      location: json['location'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      email: json['email'],
      selectedNotif: json['selectedNotif'],

      flightNumber: json['flightNumber'],
      flightDeparture: json['flightDeparture'],
      flightArrival: json['flightArrival'],

      accomodation: json['accomodation'],

      checklist: json['checklist'] != null
        ? (json['checklist'] as List)
          .map((e) => ChecklistItem.fromJson(e))
          .toList()
        : [],
      activities: json['activities'] != null
        ? (json['activities'] as List)
          .map((e) => Activity.fromJson(e))
          .toList()
        : [],
    );
  }

  static List<Plans> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Plans>((dynamic d) => Plans.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'travelPlanName': travelPlanName,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'email': email,
      'selectedNotif': selectedNotif,
      'flightNumber': flightNumber,
      'flightDeparture': flightDeparture,
      'flightArrival': flightArrival,
      'accomodation': accomodation,
      'checklist': checklist.map((e) => e.toJson()).toList(),
      'activities': activities.map((e) => e.toJson()).toList()
    };
  }
}

class ChecklistItem {
  bool checked;
  String name;

  ChecklistItem({required this.checked, required this.name});

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      checked: json['checked'] ?? false,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checked': checked,
      'name': name,
    };
  }
}

class Activity {
  String location;
  String time;
  String description;

  Activity({required this.location, required this.time, required this.description});

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'time': time,
      'description': description,
    };
  }
}