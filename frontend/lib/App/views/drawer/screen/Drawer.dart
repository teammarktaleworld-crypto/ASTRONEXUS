import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  final Function(String) onItemTap;
  final String userName; // Dynamic user name

  const CustomDrawer({
    required this.onItemTap,
    required this.userName,
    super.key,
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _drawerItem(String title, IconData icon, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-50 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onItemTap(title),
          borderRadius: BorderRadius.circular(12),
          hoverColor: Colors.white12,
          splashColor: Colors.blueAccent.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      {"title": "Terms & Conditions", "icon": Icons.description},
      {"title": "Feedback", "icon": Icons.feedback},
      {"title": "Match Services", "icon": Icons.favorite},
    ];

    return Stack(
      children: [
        // Semi-transparent overlay
        FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.black54),
          ),
        ),

        // Drawer panel
        SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF18122B),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Replace the CircleAvatar part in your drawer:
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.black26.withOpacity(0.2), // nice background
                    child: Icon(
                      Icons.person, // <-- profile icon
                      size: 50,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Dynamic user name
                  Text(
                    widget.userName,
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Drawer Items
                  ...drawerItems
                      .asMap()
                      .entries
                      .map((entry) => _drawerItem(
                      entry.value["title"] as String,
                      entry.value["icon"] as IconData,
                      entry.key))
                      .toList(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
