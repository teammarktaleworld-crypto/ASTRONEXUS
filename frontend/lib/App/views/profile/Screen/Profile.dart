import 'dart:io';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/api_services/chatbot/profile_services.dart';
import '../../Home/Screens/HomeScreen.dart';
import '../Widget/Cosmic_bg.dart';
import '../Widget/Menu_section.dart';
import '../Widget/Profile_header.dart';
import '../Widget/logOut_button.dart';
import '../Widget/premium_card.dart';
import '../Widget/stats_row.dart';

class CosmicProfileScreen extends StatefulWidget {
  const CosmicProfileScreen({super.key});

  @override
  State<CosmicProfileScreen> createState() => _CosmicProfileScreenState();
}

class _CosmicProfileScreenState extends State<CosmicProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController starController;
  FallingStarPainter? starPainter;
  bool isUploadingImage = false;

  // User info
  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String zodiacSign = "";
  String userAvatar = "";
  // User info



  @override
  void initState() {
    super.initState();

    starController =
    AnimationController(vsync: this, duration: const Duration(seconds: 20))
      ..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      starPainter = FallingStarPainter.generate(120, size, 0);
    });

    _loadUserData();
  }

  /// 🔹 Load user data from API + SharedPreferences
  Future<void> _loadUserData() async {
    try {
      await ProfileService.fetchMyProfile();

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        userName = prefs.getString("userName") ?? "Guest";
        userEmail = prefs.getString("email") ?? "";
        userPhone = prefs.getString("phone") ?? "";
        zodiacSign = prefs.getString("zodiacSign") ?? "";
        userAvatar = prefs.getString("userAvatar") ?? "";
      });
    } catch (e) {
      debugPrint("Profile load error: $e");
    }
  }

  /// 🔹 Pick and upload profile image
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() => isUploadingImage = true);

    try {
      final imageUrl =
      await ProfileService.uploadProfileImage(File(picked.path));
      if (imageUrl != null && mounted) setState(() => userAvatar = imageUrl);
    } catch (e) {
      debugPrint("Image upload failed: $e");
    } finally {
      if (mounted) setState(() => isUploadingImage = false);
    }
  }

  @override
  void dispose() {
    starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xff050B1E),
      body: Stack(
        children: [
          CosmicBackground(controller: starController, painter: starPainter),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
              ProfileHeaderCard(
              userName: userName,
              email: userEmail,
              phone: userPhone,
              zodiacSign: zodiacSign,
              userAvatar: userAvatar,
              isUploading: isUploadingImage,
              onAvatarTap: _pickAndUploadImage,
            ),
                const SizedBox(height: 20),
                const StatsRow(),
                const SizedBox(height: 24),
                const MenuSection(),
                const SizedBox(height: 24),
                // const PremiumCard(),
                const SizedBox(height: 30),
                const LogoutButton(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'Profile',
        style: GoogleFonts.dmSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}