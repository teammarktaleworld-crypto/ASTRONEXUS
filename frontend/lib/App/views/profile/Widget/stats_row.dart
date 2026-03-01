import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsRow extends StatefulWidget {
  const StatsRow({super.key});

  @override
  State<StatsRow> createState() => _StatsRowState();
}

class _StatsRowState extends State<StatsRow> {
  int planetCount = 0;
  int houseCount = 0;
  int reportsCount = 0; // Placeholder, can be fetched from API
  int chatsCount = 0;   // Placeholder, can be fetched from API

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load planets & houses count from SharedPreferences
      planetCount = prefs.getInt("planetCount") ?? 0;
      houseCount = prefs.getInt("houseCount") ?? 0;

      // TODO: Replace with real API/fetch if you have reports & chats counts
      reportsCount = 12;
      chatsCount = 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"label": "Kundli", "value": planetCount.toString(), "icon": LucideIcons.star},
      {"label": "Houses", "value": houseCount.toString(), "icon": LucideIcons.layoutDashboard},
      {"label": "Reports", "value": reportsCount.toString(), "icon": LucideIcons.file},
      {"label": "Chats", "value": chatsCount.toString(), "icon": LucideIcons.messageCircle},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats.map((e) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Colors.white12, Colors.white10],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black26,
                  ),
                  child: Icon(
                    e["icon"] as IconData,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e["value"] as String,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e["label"] as String,
                  style: GoogleFonts.dmSans(
                    color: Colors.white60,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}