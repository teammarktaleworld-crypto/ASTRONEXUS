import 'dart:math';
import 'dart:ui';
import 'package:astro_tale/App/views/Home/others/splash/splashbirth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:astro_tale/App/views/Home/others/view/splashNumerlogy.dart';
import 'package:astro_tale/App/views/Nuterational/views/splashnutrition.dart';
import 'package:astro_tale/App/views/Tarot/SplashTarot.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/horoscope/splashHoroscope.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/kundli/splashKundli.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/match/splashMatch.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/store/SplashStore.dart';

import '../../../ui_componets/cosmic/cosmic_one.dart';
import '../subscription/views/subscription_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen>
    with TickerProviderStateMixin {
  late AnimationController starController;
  late AnimationController planetController;

   FallingStarPainter? fallingStarPainter;

  @override
  void initState() {
    super.initState();

    // Controllers
    starController =
    AnimationController(vsync: this, duration: const Duration(seconds: 30))
      ..repeat();
    planetController =
    AnimationController(vsync: this, duration: const Duration(seconds: 45))
      ..repeat();

    // Initialize falling stars
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        fallingStarPainter = FallingStarPainter.generate(120, size, 0);
      });
    });
  }

  @override
  void dispose() {
    starController.dispose();
    planetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xff050B1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Services",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),

      ),
      body: Stack(
        children: [

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

          Positioned.fill(child: SmoothShootingStars()),
          // FALLING STARS LAYER
          // if (fallingStarPainter != null)
          //   AnimatedBuilder(
          //     animation: starController,
          //     builder: (_, __) {
          //       return CustomPaint(
          //         size: size,
          //         painter: FallingStarPainter(
          //           starController.value,
          //           stars: fallingStarPainter!.stars,
          //           sizes: fallingStarPainter!.sizes,
          //           speeds: fallingStarPainter!.speeds,
          //         ),
          //       );
          //     },
          //   ),

          // PLANETS
          AnimatedBuilder(
            animation: planetController,
            builder: (_, __) => _PlanetLayer(planetController.value),
          ),

          // UI CONTENT
          SafeArea(child: _content()),
        ],
      ),
    );
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 18),
          // _servicesTopBar(),
          const SizedBox(height: 28),
          Expanded(child: _servicesGrid()),
        ],
      ),
    );
  }

  PreferredSizeWidget _servicesTopBar() {
    return PreferredSize(
      preferredSize:  Size.fromHeight(500),
      child: Container(
        margin: const EdgeInsets.symmetric( vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08), // glassy effect
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Services",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Notification or Avatar

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _servicesGrid() {
    final services = [
      _ServiceData(
        "Birth Chart",
        "assets/astrology/kundli.png",
        const Color(0xFFD4AF37),
        "Detailed birth chart analysis revealing life path, strengths, and planetary influences.",
            () => _go(SplashBirth()),
      ),
      _ServiceData(
        "Tarot",
        "assets/astrology/tarot.png",
        const Color(0xFF9B8CFF),
        "Intuitive tarot guidance offering clarity on love, career, and spiritual growth.",
            () => _go(const Splashtarot()),
      ),
      _ServiceData(
        "Numerology",
        "assets/astrology/numerology.png",
        const Color(0xFF7ED6C1),
        "Decode numbers connected to your destiny, personality traits, and life cycles.",
            () => _go(const SplashNumerology()),
      ),
      _ServiceData(
        "Horoscope",
        "assets/astrology/horoscope.png",
        const Color(0xFFE3E3E3),
        "Daily planetary insights to guide decisions, emotions, and opportunities.",
            () => _go(const SplashHoroscope()),
      ),
      _ServiceData(
        "Match",
        "assets/astrology/love.png",
        const Color(0xFFFF7A7A),
        "Compatibility analysis based on planetary harmony, emotions, and future potential.",
            () => _go(const SplashMatch()),
      ),
      _ServiceData(
        "Nutrition",
        "assets/astrology/nutrition.png",
        const Color(0xFF8BE78B),
        "Personalized food guidance aligned with zodiac energy and planetary balance.",
            () => _go(const Splashnutrition()),
      ),
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: services
            .map(
              (service) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _ServiceCard(
              data: service,
              // Mark Tarot and Nutrition as premium
              isPremium: service.title == "Numerology" || service.title == "Nutrition" || service.title == "Match",
            ),
          ),
        )
            .toList(),
      ),
    );
  }


  void _go(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

/*────────────────── ORBIT AVATAR ──────────────────*/
class _OrbitAvatar extends StatelessWidget {
  const _OrbitAvatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(.4),
                blurRadius: 20,
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/planets/planet1.png"),
        ),
      ],
    );
  }
}

/*────────────────── SERVICE CARD ──────────────────*/
class _ServiceCard extends StatelessWidget {
  final _ServiceData data;
  final bool isPremium;

  const _ServiceCard({required this.data, this.isPremium = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isPremium) {
          // Navigate to subscription page for premium services
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => SubscriptionPage()),
          );
        } else {
          data.onTap();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: data.color.withOpacity(.3)),
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: [
                            data.color.withOpacity(.2),
                            data.color.withOpacity(.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          data.asset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data.title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data.description,
                            style: GoogleFonts.poppins(
                              color: Colors.white60,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),

                // LOCK ICON at top right for premium services
                if (isPremium)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*────────────────── PLANETS ──────────────────*/
class _PlanetLayer extends StatelessWidget {
  final double progress;
  const _PlanetLayer(this.progress);

  @override
  Widget build(BuildContext context) {
    final t = progress * 2 * pi;
    return Stack(
      children: [
        Positioned(
          top: 140 + sin(t) * 30,
          right: -50,
          child: Image.asset(
            "assets/planets/planet1.png",
            height: 140,
            opacity: const AlwaysStoppedAnimation(.25),
          ),
        ),
        Positioned(
          bottom: 160 + cos(t) * 25,
          left: -50,
          child: Image.asset(
            "assets/planets/planet2.png",
            height: 110,
            opacity: const AlwaysStoppedAnimation(.22),
          ),
        ),
      ],
    );
  }
}

/*────────────────── DATA MODEL ──────────────────*/
class _ServiceData {
  final String title;
  final String asset;
  final Color color;
  final String description;
  final VoidCallback onTap;

  _ServiceData(
      this.title, this.asset, this.color, this.description, this.onTap);
}

/*────────────────── OPTIMIZED FALLING STAR PAINTER ──────────────────*/
class FallingStarPainter extends CustomPainter {
  final double progress;
  final List<Offset> stars;
  final List<double> sizes;
  final List<double> speeds;

  FallingStarPainter(
      this.progress, {
        required this.stars,
        required this.sizes,
        required this.speeds,
      });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white24;
    for (int i = 0; i < stars.length; i++) {
      final y = (stars[i].dy + progress * speeds[i]) % size.height;
      canvas.drawCircle(Offset(stars[i].dx, y), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant FallingStarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }

  static FallingStarPainter generate(int count, Size size, double progress) {
    final random = Random();
    return FallingStarPainter(
      progress,
      stars: List.generate(
        count,
            (_) => Offset(random.nextDouble() * size.width,
            random.nextDouble() * size.height),
      ),
      sizes: List.generate(count, (_) => random.nextDouble() * 1.2 + 0.4),
      speeds: List.generate(count, (_) => 50 + random.nextDouble() * 250),
    );
  }
}
