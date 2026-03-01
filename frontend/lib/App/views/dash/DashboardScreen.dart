import 'package:astro_tale/App/views/Ai(chatbot)/View/Chatbot.dart';
import 'package:astro_tale/App/views/Home/Screens/HomeScreen.dart';
import 'package:astro_tale/App/views/options/optionscreen.dart';
import 'package:astro_tale/App/views/profile/Screen/Profile.dart';
import 'package:astro_tale/App/views/shop/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../Model/Horoscope/horoscope_model.dart';

class DashboardScreen extends StatefulWidget {
  final String zodiacSign;
  final HoroscopeData daily;
  final HoroscopeData weekly;
  final HoroscopeData monthly;

  const DashboardScreen({
    super.key,
    required this.zodiacSign,
    required this.daily,
    required this.weekly,
    required this.monthly,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  /// Updated nav items with AI Chatbot in the middle
  final List<Map<String, dynamic>> _navItems = const [
    {"icon": LucideIcons.house, "label": "Home"},
    {"icon": Icons.shopping_bag_outlined, "label": "Shop"},
    {"icon": LucideIcons.bot, "label": "Mati"}, // 👈 new middle tab
    {"icon": LucideIcons.layoutDashboard, "label": "Service"},
    {"icon": Icons.person_outline, "label": "Profile"},
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      Homescreen(
        zodiacSign: widget.zodiacSign,
        daily: widget.daily,
        weekly: widget.weekly,
        monthly: widget.monthly,
      ),
      const StoreScreen(),
      const MatiChatBotScreen(), // 👈 add chatbot screen here
      const ServiceScreen(),
      const CosmicProfileScreen(),
    ];
  }

  void _onTabChanged(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  Widget _buildFloatingNavItem(int index) {
    final isActive = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _onTabChanged(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(
                0,
                index == 2 ? -25 : (isActive ? -8 : 0), // ⬅ middle tab floats higher
                0,
              ),
              child: index == 2
                  ? Container(
                width: isActive ? 75 : 65, // ⬅ bigger size
                height: isActive ? 75 : 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // background for pop
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/mati.png',
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  : Icon(
                _navItems[index]["icon"],
                size: isActive ? 40 : 23,
                color: isActive ? Colors.white : Colors.white54,
              ),
            ),

            // Only show label and indicator for non-middle tabs
            if (index != 2) ...[
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.white : Colors.white54,
                ),
                child: Text(_navItems[index]["label"]),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: isActive ? 50 : 0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      body: Stack(
        children: [
          // Main Content
          _pages[_selectedIndex],

          // Floating Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff1B1B2F).withOpacity(.95),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  height: 77,
                  child: Row(
                    children: List.generate(
                      _navItems.length,
                          (index) => _buildFloatingNavItem(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}