import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astro_tale/App/views/Tarot/result/Tarot_result.dart';
import '../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../ui_componets/glass/glass_card.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  bool isLoading = false;

  void _generateTarot() {
    final name = nameController.text.trim();
    final count = int.tryParse(countController.text);

    if (name.isEmpty || count == null || count < 1 || count > 78) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter your name & choose 1–78 cards 🔮"),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TarotResult(
            name: name,
            spread: "Custom",
            cardCount: count,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: _tarotTopBar(context),
      body: Stack(
        children: [
          /// 🌌 Background Gradient
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

          /// 🌠 Shooting Stars
          Positioned.fill(child: SmoothShootingStars()),

          /// 🌑 Dark Overlay
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.45))),

          SafeArea(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ✨ Custom Glass App Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(12, topPadding + 8, 12, 20),
                  child: Row(
                    children: [
                      /// 🔙 Back Button


                      /// 🪄 Center Title (Perfectly Centered)


                      /// ✨ Right Spacer (balances the back button)
                      const SizedBox(width: 40),
                    ],
                  ),
                ),


                /// 📜 Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        /// 🔮 Glass Card
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                                color: const Color(0xFFDBC33F), width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.7),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: glassCard(
                            child: Column(
                              children: [
                                Text(
                                  "Let the Cards Speak",
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Enter your name and how many cards\nthe universe should reveal ✨",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSans(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                _glassInputField(
                                  label: "Your Name",
                                  icon: Icons.person_outline,
                                  controller: nameController,
                                ),
                                const SizedBox(height: 16),

                                _glassInputField(
                                  label: "Number of Cards (1–78)",
                                  icon: Icons.auto_awesome,
                                  controller: countController,
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 30),

                                /// ✨ Reveal Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed:
                                    isLoading ? null : _generateTarot,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF1C2A5A),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(16),
                                        side: const BorderSide(
                                            color: Color(0xFFDBC33F),
                                            width: 1.6),
                                      ),
                                      elevation: 8,
                                      shadowColor:
                                      Colors.black.withOpacity(0.6),
                                    ),
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                        color: Colors.white)
                                        : Text(
                                      "Reveal My Cards",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  /// 🔒 Glass Input Field
  Widget _glassInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.dmSans(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFFDBC33F)),
          hintText: label,
          hintStyle: GoogleFonts.dmSans(color: Colors.white54),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}

PreferredSizeWidget _tarotTopBar(BuildContext context) {
  return AppBar(
    backgroundColor: const Color(0xff050B1E),
    elevation: 0,
    centerTitle: true,
    leading: Padding(
      padding: const EdgeInsets.only(left: 12),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    ),
    title: Text(
      "tarot Reading",
      style: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
