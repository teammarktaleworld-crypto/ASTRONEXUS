import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../../helper/Widgets/Pdf_downloader.dart';
import '../../../../../../ui_componets/cosmic/cosmic_one.dart';

class BirthChartResult extends StatelessWidget {
  final Map<String, dynamic> chartData;

  const BirthChartResult({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {

    final String chartImageUrl = chartData['chartImageUrl'] ?? '';

    final houses = (chartData['houses'] ?? {}) as Map<String, dynamic>;
    final planetsInfo = (chartData['planets'] ?? {}) as Map<String, dynamic>;
    final String rashi = chartData['rashi'] ?? '';
    final String nakshatra = chartData['nakshatra'] ?? '';
    final Map<String, dynamic> ascendant =
    (chartData['ascendant'] ?? {}) as Map<String, dynamic>;
    final String ascSign = ascendant['sign'] ?? '';
    final double ascLongitude =
    (ascendant['longitude'] != null) ? (ascendant['longitude'] as num).toDouble() : 0.0;

    // Convert API houses into List<List<String>> for kundali_chart
    final chartHouses = List<List<String>>.generate(12, (index) {
      final houseNumber = (index + 1).toString();
      final items = (houses[houseNumber]?['planets'] as List?) ?? [];
      return items.map((p) {
        final sign = planetsInfo[p]?['sign'];
        return sign != null ? "$p ($sign)" : p.toString();
      }).toList();
    });

    return Scaffold(
      appBar: _BirthchartTopBar(context),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Cosmic Gradient Background
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
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.45))),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Rashi, Nakshatra, Ascendant
                Card(
                  color: Colors.white.withOpacity(0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.white24),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoText("Rashi", rashi, Colors.amberAccent),
                        const SizedBox(height: 6),
                        _infoText("Nakshatra", nakshatra, Colors.lightBlueAccent),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                            children: [
                              const TextSpan(
                                text: "Ascendant: ",
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(text: ascSign),
                              TextSpan(
                                text: " (${ascLongitude.toStringAsFixed(2)}°)",
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            width: 400,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf, color: Colors.black),
                              label: Text(
                                "Download PDF",
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amberAccent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                BirthChartPdfService.generateAndDownloadPdf(
                                  chartImageUrl: chartImageUrl,
                                  rashi: rashi,
                                  nakshatra: nakshatra,
                                  ascSign: ascSign,
                                  ascLongitude: ascLongitude,
                                );
                              },

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Kundali Chart
                Card(
                  color: Colors.white.withOpacity(0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.white24),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: SizedBox(
                        height: 450, // Bigger height for better visibility
                        width: 450,  // Make it square for proper display
                        child: // Backend Generated Kundali Chart Image
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "Generated Birth Chart",
                                style: GoogleFonts.dmSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amberAccent,
                                ),
                              ),
                              const SizedBox(height: 16),

                              if (chartImageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: InteractiveViewer(
                                    minScale: 0.5,
                                    maxScale: 4,
                                    child: chartImageUrl.endsWith(".svg")
                                        ? SvgPicture.network(chartImageUrl)
                                        : Image.network(chartImageUrl),
                                  ),
                                )
                              else
                                Text(
                                  "Chart image not available",
                                  style: GoogleFonts.dmSans(color: Colors.white54),
                                ),
                            ],
                          ),
                        ),

                      ),
                    ),
                  ),
                ),


                // Houses & Planets Details
                ...List.generate(houses.length, (index) {
                  final houseNumber = (index + 1).toString();
                  final data = houses[houseNumber] ?? {};
                  final List planets = data['planets'] ?? [];

                  return Card(


                    color: Colors.white.withOpacity(0.06),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.white24),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                              children: [
                                TextSpan(
                                  text: "House $houseNumber ",
                                  style: const TextStyle(
                                    color: Colors.amberAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: "• ${data['sign'] ?? ''}",
                                  style: const TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          planets.isNotEmpty
                              ? Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: planets.map((p) {
                              final planetSign = planetsInfo[p]?['sign'] ?? '';
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.dmSans(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: p,
                                        style: const TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: planetSign.isNotEmpty ? " ($planetSign)" : "",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                              : Text(
                            "No planets",
                            style: GoogleFonts.dmSans(
                              color: Colors.white38,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Info Text Widget
  Widget _infoText(String label, String value, Color color) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.dmSans(fontSize: 15, color: Colors.white70),
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}

/// ================= TOP BAR =================
PreferredSizeWidget _BirthchartTopBar(BuildContext context) {
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

          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    ),
    title: Text(
      "Birth Chart",
      style: GoogleFonts.dmSans(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
