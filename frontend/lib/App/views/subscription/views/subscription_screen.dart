import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astro_tale/ui_componets/cosmic/cosmic_one.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      body: Stack(
        children: [
          // 🌌 Background
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 10),
                  _subtitle(),
                  const SizedBox(height: 18),
                  _banner(),
                  const SizedBox(height: 22),

                  Text(
                    "Subscription Plans",
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: const [
                        CalmPlanCard(
                          title: "Weekly",
                          price: "₹199",
                          description: "Gentle start for guidance",
                          features: [
                            "Daily Horoscope",
                            "Basic Insights",
                          ],
                        ),
                        SizedBox(height: 14),
                        CalmPlanCard(
                          title: "Monthly",
                          price: "₹699",
                          description: "Complete astrological support",
                          highlight: true,
                          features: [
                            "Daily Horoscope",
                            "Nutritional Astrology",
                            "Exclusive Videos",
                            "Chat Support",
                          ],
                        ),
                        SizedBox(height: 14),
                        CalmPlanCard(
                          title: "Yearly",
                          price: "₹6,999",
                          description: "Deep long-term guidance",
                          features: [
                            "All Monthly Features",
                            "Priority Astrologer Support",
                            "Premium Content",
                          ],
                        ),
                        SizedBox(height: 28),
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

  // ================= HEADER =================

  Widget _header(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Upgrade Your Journey",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white12,
            ),
            child: const Icon(Icons.close, color: Colors.white70, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _subtitle() {
    return Text(
      "Choose a plan that aligns with your spiritual path and unlock deeper astrological insights.",
      style: GoogleFonts.dmSans(
        color: Colors.white60,
        fontSize: 13,
        height: 1.5,
      ),
    );
  }

  Widget _banner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        "assets/images/bg_card.png",
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

// ================= PLAN CARD =================

class CalmPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final bool highlight;

  const CalmPlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: highlight
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.15),
          width: highlight ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius:  5 ,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            price,
            style: GoogleFonts.dmSans(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),

          ...features.map(
                (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff18122B),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Subscribe",
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}