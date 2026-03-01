import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../ui_componets/cosmic/cosmic_one.dart';

class BirthDetailsScreen extends StatefulWidget {
  const BirthDetailsScreen({super.key});

  @override
  State<BirthDetailsScreen> createState() => _BirthDetailsScreenState();
}

class _BirthDetailsScreenState extends State<BirthDetailsScreen>
    with TickerProviderStateMixin {
  bool loading = true;

  late AnimationController planetController;

  String name = "";
  String birthDate = "";
  String birthTime = "";
  String birthPlace = "";
  String rashi = "";
  String nakshatra = "";
  String lagna = "";
  String chartImage = "";
  String dashaPlanet = "";
  String dashaPeriod = "";

  @override
  void initState() {
    super.initState();

    planetController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    _loadBirthDetails();
  }

  @override
  void dispose() {
    planetController.dispose();
    super.dispose();
  }

  Future<void> _loadBirthDetails() async {
    debugPrint("🔄 Loading birth details from SharedPreferences...");

    final prefs = await SharedPreferences.getInstance();

    // ───── BASIC INFO ─────
    name = prefs.getString("userName") ?? "";
    birthDate = prefs.getString("birthDate") ?? "";
    birthTime = prefs.getString("birthTime") ?? "";
    birthPlace = prefs.getString("birthPlace") ?? "";
    rashi = prefs.getString("zodiacSign") ?? "";
    nakshatra = prefs.getString("nakshatra") ?? "";
    lagna = prefs.getString("lagnam") ?? "";

    setState(() {
      chartImage = prefs.getString("chartImage") ?? "";
    });

    debugPrint("👤 Name: $name");
    debugPrint("📅 DOB: $birthDate");
    debugPrint("⏰ Time: $birthTime");
    debugPrint("📍 Place: $birthPlace");
    debugPrint("♈ Rashi: $rashi");
    debugPrint("🌟 Nakshatra: $nakshatra");
    debugPrint("⬆️ Lagna: $lagna");
    debugPrint("🖼 Chart Image URL: $chartImage");

    // ───── DASHAS ─────
    final dashasRaw = prefs.getString("dashas");
    debugPrint("📦 Raw Dashas JSON: $dashasRaw");

    if (dashasRaw != null && dashasRaw.isNotEmpty) {
      try {
        final Map<String, dynamic> dashas = jsonDecode(dashasRaw);
        final current = dashas["current_dasha"];

        if (current != null) {
          dashaPlanet = current["planet"] ?? "";
          dashaPeriod =
          "${current["start_date"] ?? ""} → ${current["end_date"] ?? ""}";

          debugPrint("🪐 Current Mahadasha Planet: $dashaPlanet");
          debugPrint("📆 Dasha Period: $dashaPeriod");
        } else {
          debugPrint("⚠️ No current_dasha found");
        }
      } catch (e) {
        debugPrint("❌ Error decoding dashas JSON: $e");
      }
    } else {
      debugPrint("⚠️ Dashas not stored in prefs");
    }

    setState(() {
      loading = false;
    });

    debugPrint("✅ Birth details loaded successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xff050B1E),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Birth Chart",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          /// 🌌 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff050B1E),
                  Color(0xff393053),
                  Color(0xff050B1E),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// ✨ STARS
          Positioned.fill(child: SmoothShootingStars()),

          /// 📜 CONTENT
          SafeArea(
            child: loading
                ? const Center(
              child:
              CircularProgressIndicator(color: Colors.white),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔮 CHART IMAGE
                  if (chartImage.isNotEmpty && chartImage.startsWith("http"))
                    _glassContainer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          chartImage,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const SizedBox(
                              height: 300,
                              child: Center(
                                child: Text(
                                  "Chart image not available",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  const SizedBox(height: 28),

                  _section("Birth Information"),
                  _glassInfo([
                    _row("Name", name),
                    _row("Date", birthDate),
                    _row("Time", birthTime),
                    _row("Place", birthPlace),
                  ]),

                  const SizedBox(height: 22),

                  _section("Astrology Details"),
                  _glassInfo([
                    _row("Rashi", rashi),
                    _row("Nakshatra", nakshatra),
                    _row("Lagna", lagna),
                  ]),

                  const SizedBox(height: 22),

                  if (dashaPlanet.isNotEmpty) ...[
                    _section("Current Mahadasha"),
                    _glassInfo([
                      _row("Planet", dashaPlanet),
                      _row("Period", dashaPeriod),
                    ]),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🧊 GLASS UI
  Widget _glassContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _glassInfo(List<Widget> children) {
    return _glassContainer(
      child: Column(children: children),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: Colors.white60,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value.isEmpty ? "-" : value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}