import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../services/api_services/tarot_api.dart';
import '../../../Model/tarot_model.dart';
import '../pdf/tarot_pdf.dart';
import '../widgets/modern_action_button.dart';
import '../widgets/modern_tarot_card.dart';
import '../../../../ui_componets/cosmic/cosmic_one.dart';

class TarotResult extends StatefulWidget {
  final String name;
  final String spread;
  final int cardCount;

  const TarotResult({
    super.key,
    required this.name,
    required this.spread,
    required this.cardCount,
  });

  @override
  State<TarotResult> createState() => _TarotResultState();
}

class _TarotResultState extends State<TarotResult> {
  late Future<List<TarotCard>> futureCards;
  int selectedTab = 0;

  final List<String> tarotImages = [
    "assets/tarot/tarot_one.png",
    "assets/tarot/tarot_two.png",
    "assets/tarot/tarot_three.png",
    "assets/tarot/tarot_one.png",
  ];

  late List<String> selectedImages;

  @override
  void initState() {
    super.initState();

    /// 🔮 Fetch EXACT number of cards requested
    futureCards = TarotApi.fetchCards(widget.cardCount);

    /// 🎲 Assign random images ONCE (fixed order)
    final random = Random();
    selectedImages = List.generate(
      widget.cardCount,
          (_) => tarotImages[random.nextInt(tarotImages.length)],
    );
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
                  Color(0xff070D26),
                  Color(0xff241A3D),
                  Color(0xff070D26),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(child: SmoothShootingStars()),
          Positioned.fill(
              child: Container(color: Colors.black.withOpacity(.55))),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: FutureBuilder<List<TarotCard>>(
                    future: futureCards,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _shimmerLoading();
                      }
                      if (snapshot.hasError) return _errorView();

                      final cards = snapshot.data!;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _headerSection(),
                            const SizedBox(height: 24),
                            _readingToggle(),
                            const SizedBox(height: 26),
                            _cardsSpread(cards),
                            const SizedBox(height: 28),
                            _dynamicInfoPanel(cards),
                            const SizedBox(height: 30),
                            _saveButton(cards),

                            const SizedBox(height: 40),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔙 APP BAR
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Color(0xFFD4AF37)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "Your Tarot Reading",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37)),
        ],
      ),
    );
  }

  /// ✨ HEADER
  Widget _headerSection() {
    return Column(
      children: [
        Text("Mystic Guidance",
            style: GoogleFonts.dmSans(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold))
            .animate()
            .fadeIn()
            .slideY(begin: 0.3),
        const SizedBox(height: 6),
        Text("Welcome, ${widget.name}",
            style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 14)),
      ],
    );
  }

  /// 🔘 TOGGLE
  Widget _readingToggle() {
    final tabs = ["Cards", "Meanings", "Insight"];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color:
                  selected ? const Color(0xFFD4AF37) : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: selected ? Colors.black : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 🃏 CARD SPREAD (dynamic count)
  Widget _cardsSpread(List<TarotCard> cards) {
    return SizedBox(
      height: 320,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          final card = cards[index];
          return ModernTarotCard(
            title: card.name,
            description: card.meaningUp,
            position: index + 1,
            imagePath: selectedImages[index],
          ).animate().fadeIn().slideY(begin: 0.2);
        },
      ),
    );
  }

  /// 📜 INFO PANEL
  Widget _dynamicInfoPanel(List<TarotCard> cards) {
    String title;
    String content;

    if (selectedTab == 0) {
      title = "Your Selected Cards";
      content = cards.map((c) => c.name).join(", ");
    } else if (selectedTab == 1) {
      title = "Card Meanings";
      content = cards.map((c) => c.meaningUp).join("\n\n");
    } else {
      title = "Spiritual Insight";
      content =
      "This spread reveals your past lessons, present path, and future possibilities. Trust your intuition and embrace the transformation ahead.";
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withOpacity(.85),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(content,
                  style: GoogleFonts.dmSans(
                      color: Colors.white70, height: 1.6, fontSize: 14)),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _saveButton(List<TarotCard> cards) {
    return ModernActionButton(
      title: "Save as PDF",
      onTap: () async {
        final pdfCards = cards.take(widget.cardCount).map((c) => {
          "title": c.name,
          "description": c.meaningUp,
        }).toList();

        await TarotPdfService.generateAndOpenPdf(
          userName: widget.name,
          spread: widget.spread,
          cards: pdfCards,
        );
      },
    ).animate().fadeIn(delay: 500.ms);
  }


  /// ✨ SHIMMER LOADING
  Widget _shimmerLoading() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          const SizedBox(height: 30),

          /// Title shimmer
          Shimmer.fromColors(
            baseColor: Colors.white10,
            highlightColor: Colors.white24,
            child: Container(height: 24, width: 180, color: Colors.white),
          ),
          const SizedBox(height: 30),

          /// Card shimmer list
          SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: 20),
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.white10,
                highlightColor: Colors.white24,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorView() => Center(
    child: Text("The cards are hidden… Try again ✨",
        style: GoogleFonts.dmSans(color: Colors.white70)),
  );
}
