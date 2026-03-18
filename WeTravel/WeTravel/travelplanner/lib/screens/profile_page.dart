import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String phoneNumber = '';
  String fullName = '';
  List<String> interests = [];
  List<String> travelStyles = [];
  User? user;
  String? pfpBase64;
  String? coverPhotoBase64;

  bool isPrivate = false;

  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneNum = RegExp(r'^(\+63|0)?9\d{9}$');
    return phoneNum.hasMatch(value) ? null : 'Enter a valid phone number';
  }

  //fetches the user's profile + pfp in base64
  Future<void> _fetchUserData() async {
    if (user == null) return;
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('emailAddress', isEqualTo: user!.email)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) {
      final doc = query.docs.first;
      final data = doc.data();
      if (data == null) return;

      if (mounted) {
        setState(() {
          fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}"
              .trim();
          userName = data['userName'] ?? '';
          phoneNumber = data['phoneNumber'] ?? '';
          interests = List<String>.from(data['interests'] ?? []);
          travelStyles = List<String>.from(data['travelStyles'] ?? []);
          pfpBase64 = (data['profileImage'] ?? '').toString();
          coverPhotoBase64 = (data['coverImage'] ?? '').toString();
          isPrivate = data['isPrivate'] ?? false; 
        });
      }
    }
  }

  Future<void> _togglePrivate(bool value) async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .where('emailAddress', isEqualTo: user!.email)
        .limit(1)
        .get();

    if (doc.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(doc.docs.first.id)
          .update({'isPrivate': value});

      setState(() {
        isPrivate = value;
      });
    }
  }

  Future<void> _pickImage(bool isPfp) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: const Color(0xFFFCF8E8),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo, color: Color(0xFF5F7060)),
              title: Text(
                'Choose from Gallery',
                style: GoogleFonts.ubuntu(color: Color(0xFF5F7060)),
              ),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                _pickImageHandler(picked, isPfp);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF5F7060)),
              title: Text(
                'Take a Photo',
                style: GoogleFonts.ubuntu(color: Color(0xFF5F7060)),
              ),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                _pickImageHandler(picked, isPfp);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageHandler(XFile? image, bool isPfp) async {
    if (image != null) {
      final bytes = await image.readAsBytes();
      String base64Image = base64Encode(bytes);
      setState(() {
        if (isPfp) {
          pfpBase64 = base64Image;
        } else {
          coverPhotoBase64 = base64Image;
        }
      });
      await _FirestoreUpdateImg(isPfp, base64Image);
    }
  }

  //updates user's profile in Firestore with the given base64 string
  Future<void> _FirestoreUpdateImg(bool isPfp, String base64Image) async {
    if (user == null) return;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .where('emailAddress', isEqualTo: user!.email)
        .limit(1)
        .get();
    if (userDoc.docs.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.docs.first.id)
          .update({isPfp ? 'profileImage' : 'coverImage': base64Image});
    }
  }

  //used to build the cover photo widget which allows the usr to tap and change the cover photo
  Widget _buildCoverPhoto() {
    return GestureDetector(
      onTap: () => _pickImage(false),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: (coverPhotoBase64 != null && coverPhotoBase64!.isNotEmpty)
            ? Image.memory(base64Decode(coverPhotoBase64!), fit: BoxFit.cover)
            : Image.asset('assets/images/cover_photo.png', fit: BoxFit.cover),
      ),
    );
  }

  //same function but with profile picture
  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () => _pickImage(true),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: (pfpBase64 != null && pfpBase64!.isNotEmpty)
            ? MemoryImage(base64Decode(pfpBase64!))
            : const AssetImage('assets/images/default_icon.png')
                  as ImageProvider,
        backgroundColor: Colors.white,
      ),
    );
  }

  //shows a dialog to edit the user's full name and phone number
  void _showEditDialog() {
    final nameController = TextEditingController(text: fullName);
    final phoneController = TextEditingController(text: phoneNumber);
    final _editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFfcfaee),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Edit Info',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5F7060),
          ),
        ),
        content: Form(
          key: _editFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: validatePhone,
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.ubuntu(color: Color(0xFF5F7060)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF607D69),
            ),
            onPressed: () async {
              if (!_editFormKey.currentState!.validate()) return;
              if (user == null) return;
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .where('emailAddress', isEqualTo: user!.email)
                  .limit(1)
                  .get();
              if (userDoc.docs.isNotEmpty) {
                final userFullName = nameController.text.trim().split(' ');
                final firstName = userFullName.isNotEmpty
                    ? userFullName.first
                    : '';
                final lastName = userFullName.length > 1
                    ? userFullName.sublist(1).join(' ')
                    : '';
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userDoc.docs.first.id)
                    .update({
                      'firstName': firstName,
                      'lastName': lastName,
                      'phoneNumber': phoneController.text.trim(),
                    });
                setState(() {
                  fullName = nameController.text;
                  phoneNumber = phoneController.text;
                });
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: GoogleFonts.ubuntu(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  //shows a dialog for editing the list of interests and travel styles
  void _showChips(
    String title,
    List<String> options,
    List<String> currentValues,
    Function(List<String>) onSave,
  ) {
    List<String> tempSelected = List.from(currentValues);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFfcfaee),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          "Edit $title",
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: Color(0xFF5F7060),
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setStateSB) => SingleChildScrollView(
            child: Wrap(
              spacing: 5,
              children: options.map((option) {
                final isSelected = tempSelected.contains(option);
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FilterChip(
                    label: Text(
                      option,
                      style: GoogleFonts.ubuntu(
                        color: isSelected ? Colors.white : Color(0xFF5F7060),
                      ),
                    ),
                    selectedColor: const Color(0xFF607D69),
                    backgroundColor: const Color(0xFFFCF8E8),
                    selected: isSelected,
                    onSelected: (selected) {
                      setStateSB(() {
                        if (selected) {
                          tempSelected.add(option);
                        } else {
                          tempSelected.remove(option);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.ubuntu(color: Color(0xFF5F7060)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF607D69),
            ),
            onPressed: () async {
              if (user == null) return;
              final userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .where('emailAddress', isEqualTo: user!.email)
                  .limit(1)
                  .get();
              if (userDoc.docs.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userDoc.docs.first.id)
                    .update({
                      title == 'Interests' ? 'interests' : 'travelStyles':
                          tempSelected,
                    });
                onSave(tempSelected);
              }
              Navigator.pop(context);
            },
            child: Text('Save', style: GoogleFonts.ubuntu(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  //used to edit interests and travel styles
  Widget _editWithChips(String title, List<String> values) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfcfaee),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: const Color(0xFF5F7060),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  values.isNotEmpty ? values.join(', ') : 'No $title',
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: const Color(0xFF5F7060),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {
              _showChips(
                title,
                title == 'Interests'
                    ? [
                        "Gaming",
                        "Music",
                        "Food",
                        "History",
                        "Travelling",
                        "Sports",
                        "Arts",
                        "Others",
                      ]
                    : [
                        "Backpacking",
                        "Luxury",
                        "Road Trips",
                        "Cultural Tours",
                        "Cruises",
                      ],
                values,
                (newValues) {
                  setState(() {
                    if (title == 'Interests') {
                      interests = newValues;
                    } else {
                      travelStyles = newValues;
                    }
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  //shows the user's full name and phone number
  Widget _userInfo(String name, String phone, VoidCallback onEdit) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfcfaee),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isNotEmpty ? name : 'No Name',
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xFF5F7060),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phone.isNotEmpty ? phone : 'No phone number',
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  color: const Color(0xFF5F7060),
                ),
              ),
            ],
          ),
          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
        ],
      ),
    );
  }

  //build the container which contains username, email, friend, and plan counts
  Widget _buildUsernameInfo(String username, String email) {
    return Positioned(
      top: 120,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDFBEC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 70),
            Text(
              username,
              style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5F7060),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: GoogleFonts.ubuntu(fontSize: 12, color: Color(0xFF5F7060)),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = userName.isNotEmpty ? userName : 'No Username';
    final email = user?.email ?? 'No email';

    return Scaffold(
      backgroundColor: const Color(0xFFefead8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildCoverPhoto(),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDFBEC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF5F7060),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  _buildUsernameInfo(username, email),
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(child: _buildProfilePicture()),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Private Account', style: GoogleFonts.ubuntu()),
                    const SizedBox(width: 8),
                    Switch(value: isPrivate, onChanged: _togglePrivate),
                  ],
                ),
              ),
              _userInfo(fullName, phoneNumber, _showEditDialog),
              const SizedBox(height: 16),
              _editWithChips('Interests', interests),
              const SizedBox(height: 16),
              _editWithChips('Preferred Travel Styles', travelStyles),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
