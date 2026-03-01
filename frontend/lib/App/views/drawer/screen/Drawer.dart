import 'package:astro_tale/App/views/Auth/terms%20and%20condition/termsandconditions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../shop/product/product_details_screen.dart';

class CustomDrawer extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String? userAvatar;
  final Function(String) onItemTap;
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const CustomDrawer({
    required this.userName,
    required this.userEmail,
    this.userAvatar,
    required this.onItemTap,
    required this.onThemeChanged,
    required this.isDarkMode,
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

  Widget _drawerItem(String title, IconData icon, int index,
      {VoidCallback? onTap}) {
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
          onTap: onTap ?? () => widget.onItemTap(title),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.blueAccent.withOpacity(0.2),
          hoverColor: Colors.grey.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, color: Colors.black26, size: 26),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      height: 250,
      width: double.infinity,
      color: Color(0xff18122B),
      child: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: Colors.grey[100],
              child: ClipOval(
                child: widget.userAvatar != null && widget.userAvatar!.isNotEmpty
                    ? Image.network(
                  widget.userAvatar!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, size: 60, color: Colors.white),
                )
                    : const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.userName,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.userEmail,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      {"title": "Terms & Conditions", "icon": Icons.description},
      {"title": "wishlist", "icon": Icons.favorite_border},
      {"title": "Match Services", "icon": Icons.miscellaneous_services},
      {"title": "Change Language", "icon": Icons.language},
      {"title": "Support", "icon": Icons.call},
      {"title": "Rate Us", "icon": Icons.star_rate},
      {"title": "Like", "icon": Icons.thumb_up},
    ];

    return Stack(
      children: [
        // Overlay
        FadeTransition(
          opacity: _fadeAnimation,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.black26),
          ),
        ),

        // Drawer
        SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(4, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _profileHeader(),
                  const SizedBox(height: 20),

                  // Scrollable drawer items
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          ...drawerItems.asMap().entries.map((entry) {
                            return _drawerItem(
                              entry.value["title"] as String,
                              entry.value["icon"] as IconData,
                              entry.key,
                              onTap: () {
                                String title = entry.value["title"] as String;
                                switch (title) {
                                  case "Terms & Conditions":
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TermsAndConditions(),
                                      ),
                                    );
                                    break;
                                  default:
                                    widget.onItemTap(title);
                                }
                              },
                            );
                          }).toList(),

                          const Divider(thickness: 1, height: 1, color: Colors.grey),
                          const SizedBox(height: 12),

                          // Theme toggle
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Dark Mode",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.black87,
                                    fontSize: 16, // slightly smaller
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Switch(
                                  activeColor: Color(0xff18122B),
                                  value: widget.isDarkMode,
                                  onChanged: (val) => widget.onThemeChanged(val),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 120),

                        ],
                      ),
                    ),
                  ),


                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

