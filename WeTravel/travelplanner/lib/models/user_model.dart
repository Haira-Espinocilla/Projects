import 'dart:convert';

class Users {
  String firstName;
  String lastName;
  String emailAddress;
  String userName;
  String phoneNumber;

  List<String> interests;
  List<String> travelStyles;
  String? profileImage;
  String? coverImage;

  List<String>? incomingRequest;
  List<String>? outgoingRequest;
  List<String>? friends;

  bool isPrivate; // New field

  Users({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.userName,
    required this.phoneNumber,
    required this.interests,
    required this.travelStyles,
    this.profileImage,
    this.coverImage,
    this.incomingRequest,
    this.outgoingRequest,
    this.friends,
    this.isPrivate = false, // Default value
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      firstName: json['firstName'],
      lastName: json['lastName'],
      emailAddress: json['emailAddress'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      interests: List<String>.from(json['interests'] ?? []),
      travelStyles: List<String>.from(json['travelStyles'] ?? []),
      profileImage: json['profileImage'],
      coverImage: json['coverImage'],
      incomingRequest: List<String>.from(json['incomingRequest'] ?? []),
      outgoingRequest: List<String>.from(json['outgoingRequest'] ?? []),
      friends: List<String>.from(json['friends'] ?? []),
      isPrivate: json['isPrivate'] ?? false, // Safe fallback
    );
  }

  static List<Users> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Users>((dynamic d) => Users.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'emailAddress': emailAddress,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'interests': interests,
      'travelStyles': travelStyles,
      'profileImage': profileImage,
      'coverImage': coverImage,
      'incomingRequest': incomingRequest,
      'outgoingRequest': outgoingRequest,
      'friends': friends,
      'isPrivate': isPrivate, // Include in JSON
    };
  }
}
