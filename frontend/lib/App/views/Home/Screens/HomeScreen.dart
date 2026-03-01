import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:astro_tale/App/controller/Auth_Controller.dart';
import 'package:astro_tale/App/views/Auth/terms%20and%20condition/termsandconditions.dart';
import 'package:astro_tale/App/views/Home/others/splash/splashbirth.dart';
import 'package:astro_tale/App/views/Home/others/view/birthchart.dart';
import 'package:astro_tale/App/views/Home/widgets/banner_corsol.dart';
import 'package:astro_tale/App/views/Tarot/SplashTarot.dart';
import 'package:astro_tale/App/views/drawer/screen/Drawer.dart';
import 'package:astro_tale/App/views/drawer/widgets/support_screen.dart';
import 'package:astro_tale/App/views/notification/screens/Notification_screen.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/horoscope/splashHoroscope.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/match/splashMatch.dart';
import 'package:astro_tale/App/views/subscription/views/subscription_screen.dart';
import 'package:astro_tale/App/views/support/screen/support_screen.dart';
import 'package:astro_tale/App/views/wishlist/screen/wishlist_screen.dart';
import 'package:astro_tale/ui_componets/glass/glass_card.dart';
import 'package:astro_tale/util/images.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../ui_componets/video/localvideocard.dart';
import '../../../Model/Horoscope/horoscope_model.dart';
import '../../Ai(chatbot)/View/Chatbot.dart';
import '../../feedback/screen/feedback_screen.dart';
import '../widgets/panchangcard.dart';
import '../widgets/service_card.dart';
import '../widgets/suggestion_card.dart';

class Homescreen extends StatefulWidget {
  final String zodiacSign;
  final HoroscopeData daily;
  final HoroscopeData weekly;
  final HoroscopeData monthly;

  const Homescreen({
    super.key,
    required this.zodiacSign,
    required this.daily,
    required this.weekly,
    required this.monthly,
  });

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  late AnimationController starController;
  late AnimationController planetController;
  int feedbackRating = 4;
  final TextEditingController feedbackCtrl = TextEditingController();
  Timer? _subscriptionTimer;
  String userName = "";
  String userPhone = "";
  String userAvatar = "";
  bool _isDarkMode = false;


  final List<Map<String, dynamic>> banners = [
    {
      "image": "assets/images/banner_mati.jpeg",
      "title": "Explore Tarot",
      "destination": Splashtarot(),
    },
    {
      "image": "assets/images/banner_tarot.jpeg",
      "title": "Check Your Horoscope",
      "destination": SplashHoroscope(),
    },
    {
      "image": "assets/images/banner_shop_one.jpeg",
      "title": "Unlock Birth Chart",
      "destination": SplashBirth(),
    },
  ];

  int currentBanner = 0; // track the active page

  int selectedTab = 0;
  final tabs = ["Today", "Week", "Month"];

  @override
  FallingStarPainter? starPainter;

  @override
  void initState() {
    super.initState();
    starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    planetController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    // Initialize stars after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        starPainter = FallingStarPainter.generate(160, size, 0);
      });
    });

    _loadUserData(); // load real user info here

    // Start subscription page timer every 2 minutes
    _subscriptionTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _showSubscriptionPage();
    });

    // Example: User's birth details (from signup/login)
  }

  @override
  void dispose() {
    starController.dispose();
    planetController.dispose();
    super.dispose();

    _subscriptionTimer?.cancel();
  }

  void _showSubscriptionPage() {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SubscriptionPage()),
      );
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString("userName") ?? "";
      userPhone = prefs.getString("userPhone") ?? "";
      userAvatar =
          prefs.getString("userAvatar") ??
          "assets/icons/sun.png"; // fallback avatar
    });
  }

  void _handleDrawerItem(String item) {
    switch (item) {
      case "Terms & Conditions":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const TermsAndConditions()));
        break;
      case "wishlist":
        Navigator.push(
            context, MaterialPageRoute(builder: (_) =>  WishlistScreen()));
        break;
      case "Match Services":
        Navigator.push(context,
            MaterialPageRoute(builder: (_) =>  BirthChartScreen()));
        break;
      case "Support":
        Navigator.push(context,
            MaterialPageRoute(builder: (_) =>  AstroSupportScreen()));
        break;
      default:
        break;
    }
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
      // Optionally, apply theme changes globally using Theme.of(context)
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      drawer: CustomDrawer(
        userName: userName,
        userEmail: userName,
        userAvatar: userAvatar,
        onItemTap: _handleDrawerItem,
        isDarkMode: _isDarkMode,
        onThemeChanged: _toggleTheme,
      ),

      backgroundColor: const Color(0xff050B1E),

      appBar: _homeAppBar(context, userName, userAvatar),

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

          /// STAR FALL BACKGROUND
          // if (starPainter != null)
          //   AnimatedBuilder(
          //     animation: starController,
          //     builder: (_, __) {
          //       final painter = starPainter!;
          //       return CustomPaint(
          //         size: MediaQuery.of(context).size,
          //         painter: FallingStarPainter(
          //           starController.value,
          //           stars: painter.stars,
          //           sizes: painter.sizes,
          //           speeds: painter.speeds,
          //         ),
          //       );
          //     },
          //   ),

          /// 🪐 MULTI PLANET LAYER
          AnimatedBuilder(
            animation: planetController,
            builder: (_, __) => _planetField(),
          ),

          /// 🌠 CONTENT
          SafeArea(
            child: CustomScrollView(
              slivers: [

                // 🔹 Banners
                SliverToBoxAdapter(child: BannerCarousel()),

                // 🔹 Sticky Tabs
                SliverPersistentHeader(
                  pinned: true, // <- STICKY
                  delegate: _SliverTabsDelegate(_tabs(), 50), // 50 is height
                ),

                // 🔹 Scrollable content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        _bigPrediction(),
                        SizedBox(height: 20),
                        astrologyServicesRow(context),
                        SizedBox(height: 34),
                        SuggestionProductList(),
                        SizedBox(height: 20),

                        _nutritionalAstrology(),
                        // SizedBox(height: 40),
                        // _supportSection(),
                        // SizedBox(height: 34),
                        // _feedbackForm(),
                        // SizedBox(height: 34),
                        // _copyrightSection(),
                        SizedBox(height: 80),
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


  PreferredSizeWidget _homeAppBar(
    BuildContext context,
    String userName,
    String userAvatar,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),

          // Profile avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white12,
            child: ClipOval(
              child: userAvatar.isNotEmpty
                  ? Image.network(
                      userAvatar,
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/icons/sun.png",
                          fit: BoxFit.cover,
                          width: 44,
                          height: 44,
                        );
                      },
                    )
                  : Image.asset(
                      "assets/icons/sun.png",
                      fit: BoxFit.cover,
                      width: 44,
                      height: 44,
                    ),
            ),
          ),

          const SizedBox(width: 12),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hi, ${userName.isNotEmpty ? userName : "Guest"}",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  "Welcome back!",
                  style: GoogleFonts.dmSans(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Notifications
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return NotificationScreen(token: AuthController.token);
                },
              ),
            );
          },
        ),

        // Subscription / money
        IconButton(
          icon: const Icon(Icons.money, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return SubscriptionPage();
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _zodiacIcon(String asset) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      child: Image.asset(asset, height: 16),
    );
  }

  Widget _videoEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Astrology Explained",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        const LocalVideoCard(
          assetPath: "assets/animation/tutorial.mp4",
          title: "How Astrology Works for You",
        ),
      ],
    );
  }

  // 🔮 CTA
  Widget _birthChartCTA() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xff6EE7F9), Color(0xff8B5CF6)],
        ),
      ),
      child: const Text(
        "Birth Chart",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _supportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Support & Guidance",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            _supportCard(
              title: "Talk to Astrologer",
              subtitle: "Instant expert guidance",
              asset: "assets/support/astrologer.jpg",
            ),
            const SizedBox(width: 16),
            _supportCard(
              title: "Help Center",
              subtitle: "FAQs & assistance",
              asset: "assets/support/help.jpg",
            ),
          ],
        ),

        const SizedBox(height: 24),

        /// 🌙 SOFT COSMIC DIVIDER
        Center(
          child: Container(
            height: 1.2,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _supportCard({
    required String title,
    required String subtitle,
    required String asset,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.06),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(asset, height: 130)),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // 📅 TABS
  // Widget _tabs() {
  //   return Container(
  //     height: 50,
  //     child: Column(
  //
  //       children: [
  //
  //         Divider(),
  //         Row(
  //           children: List.generate(tabs.length, (i) {
  //             final isSelected = selectedTab == i;
  //             return Expanded(
  //               child: GestureDetector(
  //                 onTap: () => setState(() => selectedTab = i),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       tabs[i],
  //                       style: GoogleFonts.dmSans(
  //                         fontSize: 14,
  //                         fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
  //                         color: Colors.white70,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 2),
  //                     // Yellow underline for selected tab
  //                     Container(
  //                       height: 3,
  //                       width: 40, // width of the underline
  //                       decoration: BoxDecoration(
  //                         color: isSelected ? const Color(0xffDBC33F) : Colors.transparent,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // 📊 FOCUS & MOOD
  Widget focusMoodCard({required Map<String, double> levels}) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Dynamic sizing
    final cardHeight = width < 360 ? 150.0 : 180.0;
    final circleRadius = width < 360
        ? 26.0
        : width < 600
        ? 32.0
        : 38.0;
    final fontSmall = width < 360 ? 11.0 : 13.0;
    final fontPercent = width < 360 ? 11.0 : 13.0;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: cardHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: const Color(0xFF18122B).withOpacity(0.9),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Text(
                "Focus & Mood",
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: width < 360 ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: width * 0.04),

            /// Circles
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: levels.entries.map((entry) {
                final label = entry.key;
                final percent = entry.value.clamp(0.0, 1.0);

                Color ringColor;
                if (percent <= 0.3) {
                  ringColor = Colors.redAccent;
                } else if (percent <= 0.6) {
                  ringColor = Colors.orangeAccent;
                } else {
                  ringColor = Colors.greenAccent;
                }

                return Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularPercentIndicator(
                        radius: circleRadius,
                        lineWidth: circleRadius * 0.12,
                        percent: percent,
                        center: Text(
                          "${(percent * 100).toInt()}%",
                          style: GoogleFonts.dmSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontPercent,
                          ),
                        ),
                        progressColor: ringColor,
                        backgroundColor: Colors.white12,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      SizedBox(height: width * 0.015),
                      Text(
                        label,
                        style: GoogleFonts.dmSans(
                          color: Colors.white70,
                          fontSize: fontSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // 📅 TABS
  Widget _tabs() {
    return Container(
      height: 50,
      child: Column(
        children: [
          Divider(color: Colors.white24, height: 1),
          Row(
            children: List.generate(tabs.length, (i) {
              final isSelected = selectedTab == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedTab = i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5,),
                      Text(
                        tabs[i],
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 3,
                        width: 40,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffDBC33F)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 🔮 BIG PREDICTION
  Widget _bigPrediction() {
    final now = DateTime.now();
    final formattedDate = "${now.day}-${now.month}-${now.year}";

    String headerTitle;
    String horoscopeText;

    if (selectedTab == 0) {
      headerTitle = widget.daily.title;
      horoscopeText = widget.daily.text;
    } else if (selectedTab == 1) {
      headerTitle = widget.weekly.title;
      horoscopeText = widget.weekly.text;
    } else {
      headerTitle = widget.monthly.title;
      horoscopeText = widget.monthly.text;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF14162E), Color(0xFF1A1D3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ♉ ZODIAC BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.deepPurpleAccent.withOpacity(0.45),
                ),
              ),
              child: Text(
                widget.zodiacSign.toUpperCase(),
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// 🌟 TITLE
            Text(
              headerTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            /// 📅 DATE
            Text(
              formattedDate,
              style: GoogleFonts.dmSans(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 22),

            /// SOFT GLOW DIVIDER
            Container(
              height: 1,
              width: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.deepPurpleAccent.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            /// 🔮 HOROSCOPE TEXT
            Text(
              horoscopeText,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: Colors.white70,
                fontSize: 15.8,
                height: 1.9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget astrologyServicesRow(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Services data
    final services = [
      ServiceData(
        title: "Horoscope",
        description: "Daily & monthly predictions",
        asset: "assets/icons/horoscope.png",
        color: Colors.deepPurpleAccent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SplashHoroscope()),
        ),
      ),
      // ServiceData(
      //   title: "Love",
      //   description: "Matchmaking & compatibility",
      //   asset: "assets/icons/love12.png",
      //   color: Colors.pinkAccent,
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (_) => SplashMatch()),
      //   ),
      // ),
      ServiceData(
        title: "Birth Chart",
        description: "Your complete kundli",
        asset: "assets/icons/birth_chart.png",
        color: Colors.orangeAccent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SplashBirth()),
        ),
      ),
      ServiceData(
        title: "Tarot",
        description: "Guidance through tarot cards",
        asset: "assets/icons/tarot.png",
        color: Colors.blueAccent,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Splashtarot()),
        ),
      ),
    ];

    return _glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Row(
            children: [

              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Astrology Services",
                    style: GoogleFonts.dmSans(
                      fontSize: width < 360 ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Explore your cosmic guidance",
                    style: GoogleFonts.dmSans(
                      fontSize: width < 360 ? 12 : 13,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(color: Colors.white24),

          // Services Row (compact)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: services.map((service) {
              return SizedBox(
                width: double.infinity, // two per row with spacing
                child: ServiceCard(
                  data: service,
                  isPremium: false,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }




  Widget _feedbackForm() {
    return glassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Your Feedback",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Help us refine your cosmic experience",
            style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 20),

          /// 📝 NAME FIELD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: TextField(
              style: GoogleFonts.dmSans(color: Colors.white),
              cursorColor: const Color(0xff6EE7F9),
              decoration: InputDecoration(
                hintText: "Your Name",
                hintStyle: GoogleFonts.dmSans(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// ⭐ RATING
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return GestureDetector(
                onTap: () => setState(() => feedbackRating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    i < feedbackRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 28,
                    color: const Color(0xffE7C97A), // soft gold
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 18),

          /// ✍️ MESSAGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.08),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(.08)),
            ),
            child: TextField(
              controller: feedbackCtrl,
              maxLines: 4,
              style: GoogleFonts.dmSans(color: Colors.white),
              cursorColor: const Color(0xff6EE7F9),
              decoration: InputDecoration(
                hintText: "Share your thoughts...",
                hintStyle: GoogleFonts.dmSans(color: Colors.white38),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 22),

          /// 🚀 SUBMIT
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xFF11224E),
              ),
              child: Center(
                child: Text(
                  "Submit",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nutritionalAstrology() {
    return Column(
      children: [
        _glass(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🌿 ILLUSTRATION
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.7),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],

                  ),
                  padding: const EdgeInsets.all(14),
                  child: Image.asset(

                    "assets/nutrition/food.png",
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 16),

                /// 📝 TITLE
                Text(
                  "Nutritional Astrology",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// 📝 DESCRIPTION
                Text(
                  "Personalized food guidance aligned with your zodiac energy, planetary balance, and chakra harmony.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 18),

                /// 🔮 CTA BUTTON (CLICKABLE)
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SubscriptionPage(), // 👈 your page
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xff1C4D8D),

                    ),
                    child: Text(
                      "Try Recommendation",
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                /// 🌙 SOFT COSMIC DIVIDER
              ],
            ),
          ),
        ),

        SizedBox(height: 40),
        // Center(
        //   child: Container(
        //     height: 1.2,
        //     width: double.infinity,
        //     decoration: BoxDecoration(color: Colors.white),
        //   ),
        // ),
      ],
    );
  }

  // 🪐 PLANET FIELD
  Widget _planetField() {
    final t = planetController.value * 2 * pi;
    return Stack(
      children: [
        Positioned(
          top: 100 + sin(t) * 40,
          right: -50,
          child: Image.asset(
            "assets/planets/planet1.png",
            height: 140,
            opacity: const AlwaysStoppedAnimation(.5),
          ),
        ),
        Positioned(
          bottom: 120 + cos(t) * 30,
          left: -40,
          child: Image.asset(
            "assets/planets/planet2.png",
            height: 110,
            opacity: const AlwaysStoppedAnimation(.35),
          ),
        ),
        // Positioned(
        //   top: 260 + sin(t * .6) * 20,
        //   left: 120,
        //   child: Image.asset("assets/planets/planet3.png",
        //       height: 70, opacity: const AlwaysStoppedAnimation(.25)),
        // ),
      ],
    );
  }

  // 🧭 DRAWER

  // 🧊 GLASS
  Widget _glass({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Color(0xFF1A1D3A).withOpacity(1),

        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],

      ),
      child: child,
    );
  }
}

// 🔘 RING
class _Ring extends StatelessWidget {
  final String label;
  const _Ring(this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30, width: 4),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

// 🧿 SERVICE CARD
class _Service extends StatelessWidget {
  final String title;
  final String asset;
  const _Service(this.title, this.asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(asset, height: 36),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

Widget _copyrightSection() {
  return _glass(
    child: Center(
      child: Text(
        "© 2026 AstroNexus. All rights reserved.",
        style: GoogleFonts.dmSans(color: Colors.white38, fontSize: 13),
      ),
    ),
  );
}

Widget _glass({required Widget child}) {
  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.06),
      borderRadius: BorderRadius.circular(24),
    ),
    child: child,
  );
}

// ✨ FALLING STARS PAINTER
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
      final star = stars[i];
      final speed = speeds[i];
      final y = (star.dy + progress * speed) % size.height;
      canvas.drawCircle(Offset(star.dx, y), sizes[i], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  /// Helper to generate star data
  static FallingStarPainter generate(int count, Size size, double progress) {
    final rand = Random();
    List<Offset> stars = List.generate(
      count,
      (_) => Offset(
        rand.nextDouble() * size.width,
        rand.nextDouble() * size.height,
      ),
    );
    List<double> sizes = List.generate(
      count,
      (_) => rand.nextDouble() * 1.2 + 0.4,
    );
    List<double> speeds = List.generate(
      count,
      (_) => 50 + rand.nextDouble() * 250,
    ); // pixels per animation
    return FallingStarPainter(
      progress,
      stars: stars,
      sizes: sizes,
      speeds: speeds,
    );
  }
}

// 🔵 FOCUS MODE SERVICE CARD
class _FocusService extends StatelessWidget {
  final String title;
  final String asset;
  final Color accent;

  const _FocusService({
    required this.title,
    required this.asset,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(.04),
        border: Border.all(color: accent.withOpacity(.35)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accent.withOpacity(.35), accent.withOpacity(.15)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Image.asset(asset, width: 50, height: 50),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- SERVICE RING -------------------
class _ServiceRing extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget destination;
  final double size;

  const _ServiceRing(
    this.title,
    this.iconPath, {
    required this.destination,
    this.size = 70,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final fontSize = width < 360 ? 11.0 : 13.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.08),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(size * 0.22),
              child: Image.asset(iconPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(height: size * 0.18),
          Text(
            title,
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverTabsDelegate(this.child, this.height);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Color(0xff050B1E).withOpacity(1), // background to match scaffold
      child: child,
    );
  }

  @override
  double get maxExtent => height;
  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
