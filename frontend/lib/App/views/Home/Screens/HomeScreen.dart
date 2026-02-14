import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:astro_tale/App/views/Home/others/splash/splashbirth.dart';
import 'package:astro_tale/App/views/Tarot/SplashTarot.dart';
import 'package:astro_tale/App/views/drawer/screen/Drawer.dart';
import 'package:astro_tale/App/views/notification/screens/Notification_screen.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/horoscope/splashHoroscope.dart';
import 'package:astro_tale/App/views/options/IconScreen/views/match/splashMatch.dart';
import 'package:astro_tale/App/views/subscription/views/subscription_screen.dart';
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
import '../widgets/panchangcard.dart';


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

class _HomescreenState extends State<Homescreen>
    with TickerProviderStateMixin {

  late AnimationController starController;
  late AnimationController planetController;
  int feedbackRating = 4;
  final TextEditingController feedbackCtrl = TextEditingController();
  Timer? _subscriptionTimer;
  String userName = "";
  String userPhone = "";
  String userAvatar = "";







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
      userAvatar = prefs.getString("userAvatar") ?? "assets/icons/sun.png"; // fallback avatar
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
        userName: userName, // <-- pass the real user name dynamically
        onItemTap: (item) {
          Navigator.pop(context);

          switch (item) {
            case "Terms & Conditions":
            // Show terms
              break;
            case "Feedback":
            // Show feedback
              break;
            case "Match Services":
            // Open match services
              break;
          }
        },
      )
      ,


      backgroundColor: const Color(0xff050B1E),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Home",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: (){

              Navigator.push(context, MaterialPageRoute(builder: (_){
                return NotificationScreen();
              }));
            },
          ),
          IconButton(
            icon: const Icon(Icons.money),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_){
                return SubscriptionPage();
              }));
            },
          ),
        ],
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
            child: Stack(
              children: [
                Column(
                  children: [

                    // _servicesTopBar(),
                    _profileHeader(),


                    const SizedBox(height: 16),
                    _tabs(),


                    /// 🔹 SCROLLABLE CONTENT BELOW
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            // SizedBox(height: 28),
                            // focusMoodCard(
                            //   levels: {
                            //     "Career": 0.6,
                            //     "Love": 0.7,
                            //     "Health": 0.65,
                            //     "Family": 0.55,
                            //   },
                            // ),
                            //

                            SizedBox(height: 5),
                            _bigPrediction(),
                            SizedBox(height: 20,),

                            _astrologyServicesRow(),
                            const SizedBox(height: 34),
                            _videoEducationSection(),
                            const SizedBox(height: 34),
                            _nutritionalAstrology(),
                            const SizedBox(height: 40),
                            _services(),
                            const SizedBox(height: 40),
                            _supportSection(),
                            const SizedBox(height: 34),

                            _feedbackForm(),



                            const SizedBox(height: 34),

                            _copyrightSection(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                /// 🟢 MATI CHATBOT BUTTON — FLOATING ABOVE
                _matiChatBot(context)
              ],
            ),
          ),
        ],
      ),
    );
  }


  // TOP BAR
  PreferredSizeWidget _servicesTopBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Button
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white70),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),

                  // Title
                  Text(
                    "Home",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),

                  // Notification or Avatar
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white70),
                    onPressed: () {
                      // Handle notifications
                    },
                  ),

                  IconButton(
                    icon: const Icon(Icons.monetization_on, color: Colors.white70),
                    onPressed: _showSubscriptionPage,
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }




  // 🧿 PROFILE HEADER
  Widget _profileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 50,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        child: ClipOval(

                          child: userAvatar.isNotEmpty
                              ? Image.asset(userAvatar, fit: BoxFit.cover)
                              : FluttermojiCircleAvatar(radius: 50),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FluttermojiCustomizer()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  userName.isNotEmpty ? userName : "Guest",
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ],
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
            Center(child: Image.asset(asset, height: 130,)),
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
              style: GoogleFonts.dmSans(
                color: Colors.white54,
                fontSize: 12,
              ),
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
  Widget focusMoodCard({
    required Map<String, double> levels,
  }) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Dynamic sizing
    final cardHeight = width < 360 ? 150.0 : 180.0;
    final circleRadius = width < 360 ? 26.0 : width < 600 ? 32.0 : 38.0;
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
                      Text(
                        tabs[i],
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 3,
                        width: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xffDBC33F) : Colors.transparent,
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
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF14162E), Color(0xFF14162E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// ♉ Zodiac Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.4)),
                ),
                child: Text(
                  widget.zodiacSign.toUpperCase(),
                  style: GoogleFonts.dmSans(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// 🌟 Title
              Text(
                headerTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              /// 📅 Date
              Text(
                formattedDate,
                style: GoogleFonts.dmSans(
                  color: Colors.amber,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 14),
              Divider(color: Colors.white12),
              const SizedBox(height: 14),

              /// 🔮 FULL Horoscope Text
              Text(
                horoscopeText,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  color: Colors.white70,
                  fontSize: 15.5,
                  height: 1.9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }











  Widget _astrologyServicesRow() {
    final width = MediaQuery.of(context).size.width;

    // Responsive sizing
    final titleSize = width < 360 ? 15.0 : 17.0;
    final spacing = width < 360 ? 10.0 : 16.0;
    final runSpacing = width < 360 ? 12.0 : 18.0;

    return _glass(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Astrology Services",
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: titleSize,
                ),
              ),
            ),

            SizedBox(height: spacing),

            /// Responsive Wrap instead of Row
            Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: spacing,
              runSpacing: runSpacing,
              children: [
                _ServiceRing(
                  "Horoscope",
                  "assets/icons/horoscope.png",
                  size: width < 360 ? 60 : 72,
                  destination: SplashHoroscope(),
                ),
                _ServiceRing(
                  "Love",
                  "assets/icons/love12.png",
                  size: width < 360 ? 60 : 72,
                  destination: SplashMatch(),
                ),
                _ServiceRing(
                  "Birth Chart",
                  "assets/icons/birth_chart.png",
                  size: width < 360 ? 60 : 72,
                  destination: SplashBirth(),
                ),
                _ServiceRing(
                  "Tarot",
                  "assets/icons/tarot.png",
                  size: width < 360 ? 60 : 72,
                  destination: Splashtarot(),
                ),
              ],
            ),

            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }





  // 🧿 SERVICES
  // 🧿 ASTROLOGY SERVICES — FOCUS MODE STYLE
  Widget _services() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: Color(0xFF18122B),

        border: Border.all(color: Colors.white.withOpacity(.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 22,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🧠 Title
          Text(
            "Astrology Services",
            style: GoogleFonts.dmSans(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),

          // 🧿 Services Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: const [
              _FocusService(
                title: "Daily Horoscope",
                asset: "assets/icons/daily.png",
                accent: Color(0xff6EE7F9),
              ),
              _FocusService(
                title: "Love Compatibility",
                asset: "assets/icons/love.png",
                accent: Color(0xffF59EAE),
              ),
              _FocusService(
                title: "Career Guidance",
                asset: "assets/icons/career.png",
                accent: Color(0xff6EE7B7),
              ),
              _FocusService(
                title: "Health Astrology",
                asset: "assets/icons/health.png",
                accent: Color(0xff93C5FD),
              ),
            ],
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
            style: GoogleFonts.dmSans(
              color: Colors.white54,
              fontSize: 13,
            ),
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
          )
        ],
      ),
    );
  }


  Widget _nutritionalAstrology() {
    return _glass(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🌿 ILLUSTRATION ON TOP
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  "assets/nutrition/food.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 📝 TITLE
            Text(
              "Nutritional Astrology",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            // 📝 DESCRIPTION
            Text(
              "Personalized food guidance aligned with your zodiac energy, planetary balance, and chakra harmony.",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: Colors.white60,
                fontSize: 13,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 16),

            // 🔮 CTA BUTTON
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          ],
        ),
      ),
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
          child: Image.asset("assets/planets/planet1.png",
              height: 140, opacity: const AlwaysStoppedAnimation(.5)),
        ),
        Positioned(
          bottom: 120 + cos(t) * 30,
          left: -40,
          child: Image.asset("assets/planets/planet2.png",
              height: 110, opacity: const AlwaysStoppedAnimation(.35)),
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
        color: Color(0xFF18122B).withOpacity(0.9),

        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
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
        Text(label,
            style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 12)),
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
          Text(title,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: Colors.white70)),
        ],
      ),
    );
  }



}

// 🟢 MATI CHATBOT BUTTON WITH TEXT
Widget _matiChatBot(BuildContext context) {
  return Positioned(
    bottom: 26,
    right: 22,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          shape: const CircleBorder(),
          elevation: 6, // shadow
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MatiChatBotScreen()),
              );
            },
            child: Image.asset(
              Images.mati,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 6), // space between image and text
        const Text(
          "Mati",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14, // small text
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}




Widget _copyrightSection() {
  return _glass(
    child: Center(
      child: Text(
        "© 2026 AstroNexus. All rights reserved.",
        style: GoogleFonts.dmSans(
          color: Colors.white38,
          fontSize: 13,
        ),
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
          (_) => Offset(rand.nextDouble() * size.width, rand.nextDouble() * size.height),
    );
    List<double> sizes = List.generate(count, (_) => rand.nextDouble() * 1.2 + 0.4);
    List<double> speeds = List.generate(count, (_) => 50 + rand.nextDouble() * 250); // pixels per animation
    return FallingStarPainter(progress, stars: stars, sizes: sizes, speeds: speeds);
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
                colors: [
                  accent.withOpacity(.35),
                  accent.withOpacity(.15),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(1),
              child: Image.asset(asset,width: 50,height: 50,),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => destination),
        );
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






