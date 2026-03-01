import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../ui_componets/glass/glass_card.dart';

class AstroSupportScreen extends StatelessWidget {
  const AstroSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌌 Cosmic Gradient Background
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

          // 🌠 Shooting Stars
          Positioned.fill(child: SmoothShootingStars()),

          // Dark overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔙 App Bar
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon:
                        const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "Astro Support",
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
                          height: 140,
                          width: 280,
                        ),

                        const SizedBox(height: 20),

                        // 🧿 Main Glass Card
                        glassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _centerTitle("Welcome to AstroNexus Support"),

                              _centerSubtitle(
                                "Your cosmic guide to astrology insights, technical help, and spiritual clarity.",
                              ),

                              const SizedBox(height: 30),

                              // 🌙 Astrology Section
                              _sectionTitle("🌙 Astrology & Cosmic Guidance"),
                              _sectionText(
                                "AstroNexus is built on ancient astrological wisdom combined with modern cosmic interpretations. Astrology helps you understand planetary movements, zodiac influences, and how celestial energies shape your life journey.",
                              ),
                              _sectionText(
                                "Each birth chart is unique. Your zodiac sign, moon placement, rising sign, and planetary aspects all interact to form your personality, strengths, challenges, and destiny patterns.",
                              ),
                              _sectionText(
                                "Our app provides daily horoscopes, compatibility insights, planetary transits, and spiritual interpretations designed to help you align with the universe.",
                              ),

                              // ✨ Zodiac Info
                              _sectionTitle("✨ Zodiac Signs Overview"),
                              _sectionText(
                                "The zodiac consists of 12 signs, each governed by different elements and ruling planets. Fire signs are passionate and energetic, Earth signs are grounded and practical, Air signs are intellectual and communicative, and Water signs are emotional and intuitive.",
                              ),
                              _sectionText(
                                "Understanding your zodiac sign helps you recognize behavioral patterns, emotional needs, and life motivations. AstroNexus presents this information in a clear and intuitive way.",
                              ),

                              // 🪐 Planetary Influence
                              _sectionTitle("🪐 Planetary Influence"),
                              _sectionText(
                                "Planets such as Mercury, Venus, Mars, Jupiter, and Saturn influence communication, love, ambition, growth, and discipline. Their movements across zodiac signs can trigger changes in emotions, relationships, and life events.",
                              ),
                              _sectionText(
                                "Retrogrades, eclipses, and transits are all important cosmic events. AstroNexus tracks these events and translates them into easy-to-understand guidance.",
                              ),

                              // 🛠 Support Section
                              _sectionTitle("🛠 App Support & Assistance"),
                              _sectionText(
                                "If you experience issues such as login problems, missing horoscope data, app crashes, or slow performance, our support team is here to help.",
                              ),
                              _sectionText(
                                "Ensure your app is updated to the latest version for the best experience. Many issues are resolved through updates that include performance improvements and bug fixes.",
                              ),

                              // ❓ FAQ
                              _sectionTitle("❓ Frequently Asked Questions"),
                              _sectionText(
                                "• Why is my horoscope not updating?\n"
                                    "Horoscope updates depend on network connectivity and server synchronization.\n\n"
                                    "• Is my data secure?\n"
                                    "Yes, AstroNexus uses industry-standard encryption to protect user data.\n\n"
                                    "• Can I change my birth details?\n"
                                    "Yes, birth details can be updated from profile settings.",
                              ),

                              // 📩 Contact
                              _sectionTitle("📩 Contact Support"),
                              _sectionText(
                                "If you need further assistance, you can contact our support team directly through the app. We usually respond within 24–48 hours.",
                              ),
                              _sectionText(
                                "AstroNexus values your spiritual journey and technical experience equally. Your feedback helps us grow.",
                              ),

                              const SizedBox(height: 20),

                              Center(
                                child: Text(
                                  "✨ Stay aligned with the cosmos ✨",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white60,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
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

  Widget _centerTitle(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _centerSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 22),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          color: Colors.white70,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }
}