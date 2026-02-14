import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../ui_componets/glass/glass_card.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Gradient Cosmic Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff050B1E),
                  // Color(0xff1C4D8D),
                  // Color(0xff0F2854),
                  Color(0xff393053),
                  Color(0xff050B1E),

                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🌟 Shooting Stars Overlay
          Positioned.fill(child: SmoothShootingStars()),

          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔙 Custom AppBar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Terms & Conditions",
                        style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // 🌟 Logo
                        Image.asset(
                          "assets/images/logo.png",
                          height: 150,
                          width: 300,
                        ),

                        // Glassy Card for Terms
                        glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Welcome to AstroNexus",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "By using our application, you agree to the following Terms and Conditions. Please read them carefully.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              _sectionTitle("1. Acceptance of Terms"),
                              _sectionText(
                                "By creating an account or using our services, you agree to comply with and be bound by these Terms and Conditions.",
                              ),

                              _sectionTitle("2. User Responsibilities"),
                              _sectionText(
                                "You agree to use the app only for lawful purposes and not to misuse or harm the platform or other users.",
                              ),

                              _sectionTitle("3. Account Security"),
                              _sectionText(
                                "You are responsible for maintaining the confidentiality of your login credentials and activities.",
                              ),

                              _sectionTitle("4. Privacy Policy"),
                              _sectionText(
                                "We respect your privacy. Your personal data is handled securely and not shared without consent.",
                              ),

                              _sectionTitle("5. Limitation of Liability"),
                              _sectionText(
                                "AstroNexus is not liable for any damages arising from the use or inability to use the app.",
                              ),

                              _sectionTitle("6. Updates to Terms"),
                              _sectionText(
                                "We may update these Terms at any time. Continued usage implies acceptance of changes.",
                              ),

                              const SizedBox(height: 30),

                              // ✅ I Agree Button


                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===== Helpers =====
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 16),
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          color: const Color(0xFFDBC33F),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _sectionText(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        color: Colors.white70,
        fontSize: 14,
        height: 1.5,
      ),
    );
  }
}
