import 'dart:convert';
import 'dart:ui';
import 'package:astro_tale/App/views/Home/others/output/birthchart/birthchart_result.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../ui_componets/cosmic/cosmic_one.dart';
import '../../../../../ui_componets/glass/glass_card.dart';

class BirthChartScreen extends StatefulWidget {
  const BirthChartScreen({super.key});

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final placeController = TextEditingController();

  String gender = 'male';
  String astrologyType = 'vedic';
  String ayanamsa = 'lahiri';
  bool isLoading = false;

  /// ================= DATE PICKER =================
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: "SELECT BIRTH DATE",
      cancelText: "CANCEL",
      confirmText: "OK",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37), // Gold accent
              onPrimary: Colors.black,
              surface: Color(0xff1B1F3B), // Dialog background
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xff141833),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFD4AF37),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }


  /// ================= TIME PICKER =================
  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "SELECT BIRTH TIME",
      cancelText: "CANCEL",
      confirmText: "OK",
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Color(0xff141833),
              hourMinuteTextColor: Colors.white,
              hourMinuteColor: Color(0xff1B1F3B),
              dialHandColor: Color(0xFFD4AF37),
              dialBackgroundColor: Color(0xff1B1F3B),
              entryModeIconColor: Color(0xFFD4AF37),
            ),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD4AF37), // Gold accent
              onPrimary: Colors.black,
              surface: Color(0xff141833),
              onSurface: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFD4AF37),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final minute = picked.minute.toString().padLeft(2, '0');
      final period = picked.period == DayPeriod.am ? "AM" : "PM";

      timeController.text = "$hour:$minute $period";
    }
  }

  /// ================= PARSE DATE & TIME =================
  Map<String, dynamic> _parseBirthDate() {
    final parts = dateController.text.split('-');
    return {
      "year": int.parse(parts[0]),
      "month": int.parse(parts[1]),
      "day": int.parse(parts[2]),
    };
  }

  Map<String, dynamic> _parseBirthTime() {
    final parts = timeController.text.split(' ');
    final hm = parts[0].split(':');
    return {
      "hour": int.parse(hm[0]),
      "minute": int.parse(hm[1]),
      "ampm": parts[1],
    };
  }

  /// ================= GENERATE CHART =================
  Future<void> _generateChart() async {
    if (nameController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        placeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all birth details")),
      );
      return;
    }

    setState(() => isLoading = true);

    final payload = {
      "name": nameController.text.trim(),
      "gender": gender,
      "birth_date": _parseBirthDate(),
      "birth_time": _parseBirthTime(),
      "place_of_birth": placeController.text.trim(),
      "astrology_type": astrologyType,
      "ayanamsa": ayanamsa,
    };

    try {
      /// 🔵 CALL API 1 → Astrology Data
      final dataResponse = await http.post(
        Uri.parse("https://astro-nexus-backend-9u1s.onrender.com/api/v1/chart"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (dataResponse.statusCode != 200 && dataResponse.statusCode != 201) {
        throw Exception("Astro data failed: ${dataResponse.body}");
      }

      final astroData = jsonDecode(dataResponse.body);

      /// 🟣 CALL API 2 → Chart Image
      final imageResponse = await http.post(
        Uri.parse("https://astro-nexus-new-6.onrender.com/api/birthchart/generate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (imageResponse.statusCode != 200 && imageResponse.statusCode != 201) {
        throw Exception("Chart image failed: ${imageResponse.body}");
      }

      final imageJson = jsonDecode(imageResponse.body);

      final chartImagePath = imageJson["data"]?["chartImage"];

      /// 🟢 MERGE BOTH RESPONSES
      astroData["chartImageUrl"] =
      "https://astro-nexus-new-6.onrender.com$chartImagePath";

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BirthChartResult(chartData: astroData),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _BirthchartTopBar(context),
      body: Stack(
        children: [
          // Cosmic Gradient
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
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
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
                        BoxShadow(
                          color: Colors.white.withOpacity(0.05),
                          blurRadius: 30,
                          spreadRadius: 1,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: glassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.dmSans(
                                    fontSize: 18,
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    const TextSpan(text: "Generate Your "),
                                    TextSpan(
                                      text: "Birth Chart",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: " Astrology"),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            _glassInput(
                                "Full Name", Icons.person, nameController),
                            _glassInput("Date of Birth", Icons.calendar_today,
                                dateController,
                                readOnly: true, onTap: _pickDate),
                            _glassInput("Time of Birth", Icons.access_time,
                                timeController,
                                readOnly: true, onTap: _pickTime),
                            _glassInput("Place of Birth", Icons.location_on,
                                placeController),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _glassDropdown(
                                      "Gender", gender, ["male", "female"],
                                          (v) => setState(() => gender = v)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _glassDropdown(
                                      "Astrology", astrologyType,
                                      ["vedic", "western"],
                                          (v) =>
                                          setState(() => astrologyType = v)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            SizedBox(
                              height: 54,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _generateChart,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amberAccent,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: isLoading
                                    ? LoadingAnimationWidget.fourRotatingDots(
                                  color: Colors.white,
                                  size: 32,
                                )
                                    : Text(
                                  "Generate Chart",
                                  style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),

                          ],
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

  /// ================= GLASS INPUT =================
  Widget _glassInput(String label, IconData icon,
      TextEditingController controller,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              onTap: onTap,
              style: GoogleFonts.dmSans(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.white),
                hintText: label,
                hintStyle: GoogleFonts.dmSans(color: Colors.white54),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= GLASS DROPDOWN =================
  Widget _glassDropdown(
      String label, String value, List<String> items, ValueChanged<String> onChanged) =>
      DropdownButtonFormField<String>(
        value: value,
        dropdownColor: const Color(0xff1C2A5A),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e.toUpperCase(),
              style: GoogleFonts.dmSans(color: Colors.white)),
        ))
            .toList(),
        onChanged: (v) => onChanged(v!),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: GoogleFonts.dmSans(color: Colors.white),
      );
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
