import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherProfilePage extends StatefulWidget {
  const OtherProfilePage({super.key});

  @override
  State<OtherProfilePage> createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  String userName = '';
  String phoneNumber = '';
  String fullName = '';
  String email = '';
  List<String> interests = [];
  List<String> travelStyles = [];
  String? pfpBase64;
  String? coverPhotoBase64;
  bool isPrivate = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _loadUser(args);
    });
  }

  void _loadUser(Map<String, dynamic> data) {
    setState(() {
      fullName = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();
      userName = data['userName'] ?? '';
      phoneNumber = data['phoneNumber'] ?? '';
      email = data['emailAddress'] ?? '';
      interests = List<String>.from(data['interests'] ?? []);
      travelStyles = List<String>.from(data['travelStyles'] ?? []);
      pfpBase64 = (data['profileImage'] ?? '').toString();
      coverPhotoBase64 = (data['coverImage'] ?? '').toString();
      isPrivate = data['isPrivate'] == true;
    });
  }

  Widget _buildCoverPhoto() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child:
          (coverPhotoBase64 != null && coverPhotoBase64!.isNotEmpty)
              ? Image.memory(base64Decode(coverPhotoBase64!), fit: BoxFit.cover)
              : Image.asset('assets/images/cover_photo.png', fit: BoxFit.cover),
    );
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 60,
      backgroundImage:
          (pfpBase64 != null && pfpBase64!.isNotEmpty)
              ? MemoryImage(base64Decode(pfpBase64!))
              : const AssetImage('assets/images/default_icon.png')
                  as ImageProvider,
      backgroundColor: Colors.white,
    );
  }

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
                color: const Color(0xFF5F7060),
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

  Widget _userInfo(String name, String phone) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfcfaee),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
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
    );
  }

  Widget _infoBlock(String title, List<String> values) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFfcfaee),
        borderRadius: BorderRadius.circular(16),
      ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildUsernameInfo(userName, email),
                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(child: _buildProfilePicture()),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              if (!isPrivate) ...[
                _userInfo(fullName, phoneNumber),
                const SizedBox(height: 16),
                _infoBlock('Interests', interests),
                const SizedBox(height: 16),
                _infoBlock('Preferred Travel Styles', travelStyles),
              ],
              if (isPrivate) ...[
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'This user has a private account.',
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF5F7060),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
