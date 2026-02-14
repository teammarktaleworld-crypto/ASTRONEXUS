import 'package:astro_tale/App/views/Home/Screens/HomeScreen.dart';
import 'package:astro_tale/App/views/options/optionscreen.dart';
import 'package:astro_tale/App/views/profile/Screen/Profile.dart';
import 'package:astro_tale/App/views/report/screen/Flow_screen_f/Report_screen.dart';
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
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  final List<Map<String, dynamic>> _navItems = [
    {"icon": LucideIcons.house, "label": "Home", "color": Colors.white},
    {"icon": Icons.shopping_bag_outlined, "label": "Shop", "color": Colors.white}, // New Shop
    {"icon": LucideIcons.layoutDashboard, "label": "Service", "color": Colors.white},
    {"icon": LucideIcons.file, "label": "Report", "color": Colors.white},
    {"icon": Icons.person_outline_outlined, "label": "Profile", "color": Colors.white},
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
      StoreScreen(),
      ServiceScreen(),
      ReportsScreen(),
      CosmicProfileScreen(),
    ];
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildNavItem(int index) {
    final bool isActive = _selectedIndex == index;
    final Color activeColor = _navItems[index]["color"];
    final Color inactiveColor = Colors.white38;

    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, isActive ? -8 : 0),
              child: AnimatedScale(
                scale: isActive ? 2.2 : 1.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                child: Icon(
                  _navItems[index]["icon"],
                  size: 26,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: GoogleFonts.dmSans(
                color: isActive ? activeColor : inactiveColor,
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.normal,
              ),
              child: Text(_navItems[index]["label"]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xff18122B),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _navItems.length,
                (index) => _buildNavItem(index),
          ),
        ),
      ),
    );
  }
}
