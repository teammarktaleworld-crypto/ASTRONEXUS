import 'dart:ui';
import 'package:astro_tale/ui_componets/cosmic/cosmic_one.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      body: Stack(
        children: [
          // 🌌 Background Gradient
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

          Positioned.fill(child: SmoothShootingStars()),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 🔹 HEADER ROW (Title + Close Button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Upgrade Your Experience",
                          style: GoogleFonts.dmSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white12,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Unlock personalized readings, nutritional astrology insights, and exclusive content.",
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🌟 BANNER
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/bg_card.png"),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.white24),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 PLANS SECTION
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Text(
                          "Choose Your Plan",
                          style: GoogleFonts.dmSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Plan Cards
                        SubscriptionPlanCard(
                          title: "Monthly Plan",
                          price: "\$9.99",
                          features: [
                            "Daily Horoscope",
                            "Nutritional Astrology",
                            "Exclusive Videos"
                          ],
                          accent: const Color(0xff6EE7F9),
                        ),
                        const SizedBox(height: 12),
                        SubscriptionPlanCard(
                          title: "Yearly Plan",
                          price: "\$99.99",
                          features: [
                            "All Monthly Features",
                            "Priority Astrologer Support",
                            "Premium Content Access"
                          ],
                          accent: const Color(0xff8B5CF6),
                        ),
                        const SizedBox(height: 12),
                        SubscriptionPlanCard(
                          title: "Weekly Plan",
                          price: "\$3.99",
                          features: [
                            "Limited Daily Horoscope",
                            "Basic Insights"
                          ],
                          accent: const Color(0xffF59EAE),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final Color accent;
  final bool highlight;

  const SubscriptionPlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    required this.accent,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: highlight ? accent.withOpacity(0.15) : Colors.white.withOpacity(0.06),
        border: Border.all(
            color: highlight ? accent : Colors.white.withOpacity(0.08),
            width: highlight ? 2 : 1),
        boxShadow: highlight
            ? [
          BoxShadow(
            color: accent.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: GoogleFonts.dmSans(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, size: 16, color: accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.dmSans(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: highlight
                      ? [accent, accent.withOpacity(0.8)]
                      : [Colors.white12, Colors.white24],
                ),
              ),
              child: Center(
                child: Text(
                  "Subscribe Now",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
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
