import 'package:astro_tale/App/views/subscription/views/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../../services/api_services/horoscope_api.dart';
import '../../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../../../ui_componets/glass/glass_card.dart';

class HoroscopeDetailScreen extends StatefulWidget {
  final String sign;

  const HoroscopeDetailScreen({super.key, required this.sign});

  @override
  State<HoroscopeDetailScreen> createState() =>
      _HoroscopeDetailScreenState();
}

class _HoroscopeDetailScreenState extends State<HoroscopeDetailScreen>
    with SingleTickerProviderStateMixin {
  String selectedType = "daily";
  bool isLoading = true;

  String? title;
  String? horoscopeText;
  Map<String, dynamic>? extraData;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fetchHoroscope();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  Future<void> _fetchHoroscope() async {
    setState(() => isLoading = true);

    final result = await HoroscopeApi.fetchHoroscope(
      sign: widget.sign,
      type: selectedType,
    );

    setState(() {
      title = result["title"];
      horoscopeText = result["horoscope"];
      extraData = result["extra"];
      isLoading = false;
    });

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🌌 Background
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
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🔙 Header
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Text(
                        "${widget.sign} Horoscope",
                        style: GoogleFonts.dmSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFDBC33F),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🔘 Toggle
                  _buildToggleRow(),

                  const SizedBox(height: 18),

                  /// 🪐 Visual Section
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        "assets/reports/investment.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// 📜 Horoscope Content
                  Expanded(
                    child: glassCard(
                      child: isLoading
                          ? Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.white,
                          size: 46,
                        ),
                      )
                          : FadeTransition(
                        opacity: _fadeAnimation,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                "Cosmic Insight for ${widget.sign}",
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),

                              if (title != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  title!,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.yellow,
                                    fontSize: 14,
                                  ),
                                ),
                              ],

                              /// 🌙 Monthly Meta
                              if (selectedType == "monthly" &&
                                  extraData != null) ...[
                                const SizedBox(height: 16),
                                Container(
                                  width: 300,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius:
                                    BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.white24),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Standout Days",
                                        style: GoogleFonts.dmSans(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        extraData!["standout_days"],
                                        style: GoogleFonts.dmSans(
                                          color: Colors.white70,
                                          fontSize: 19,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Challenging Days",
                                        style: GoogleFonts.dmSans(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        extraData!["challenging_days"],
                                        style: GoogleFonts.dmSans(
                                          color: Colors.white60,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),
                              const Divider(color: Colors.white24),
                              const SizedBox(height: 12),

                              Text(
                                horoscopeText ?? "",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  height: 1.7,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  /// 🔘 Toggle Buttons
  Widget _buildToggleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _toggleButton("Daily", "daily"),
        const SizedBox(width: 10),
        _toggleButton("Weekly", "weekly"),
        const SizedBox(width: 10),
        _toggleButton("Monthly", "monthly"),
      ],
    );
  }

  Widget _toggleButton(String label, String type) {
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        setState(() => selectedType = type);
        _fetchHoroscope();
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color:
          isSelected ? const Color(0xFFDBC33F) : Colors.white10,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.black : Colors.white70,
          ),
        ),
      ),
    );
  }
}
