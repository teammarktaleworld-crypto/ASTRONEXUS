import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // User info
  String userName = "";
  String userEmail = "";
  String zodiacSign = "";
  String birthDate = "";
  String userAvatar = "";

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

    _loadUserData(); // load real data
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("userName") ?? "Guest";
      userEmail = prefs.getString("userEmail") ?? "guest@example.com";
      zodiacSign = prefs.getString("zodiacSign") ?? "Taurus";
      birthDate = prefs.getString("birthDate") ?? "01-01-2000";
      userAvatar = prefs.getString("userAvatar") ?? "assets/icons/sun.png";
    });
  }

  @override
  void dispose() {
    starController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      body: Stack(
        children: [
          CosmicBackground(
            controller: starController,
            painter: starPainter,
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ProfileHeaderCard(
                  userName: userName,
                  email: userEmail,
                  zodiacSign: zodiacSign,
                  birthDate: birthDate,
                  userAvatar: userAvatar,
                ),
                const SizedBox(height: 20),
                const StatsRow(),
                const SizedBox(height: 24),
                const MenuSection(),
                const SizedBox(height: 24),
                const PremiumCard(),
                const SizedBox(height: 30),
                const LogoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
