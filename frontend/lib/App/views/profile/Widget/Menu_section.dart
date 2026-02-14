import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  static const List<Map<String, dynamic>> menus = [
    {"title": "Personal Details", "icon": LucideIcons.user},
    {"title": "Birth Details / Kundli", "icon": LucideIcons.cake},
    {"title": "Consultation History", "icon": LucideIcons.history},
    {"title": "Wallet & Payments", "icon": LucideIcons.wallet},
    {"title": "Subscriptions", "icon": LucideIcons.archive},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        menus.length,
            (index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // bright glass effect
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2), // subtle outline
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      menus[index]["icon"],
                      size: 22,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        menus[index]["title"],
                        style: GoogleFonts.dmSans(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      size: 22,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
