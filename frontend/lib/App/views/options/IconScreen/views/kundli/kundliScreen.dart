import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astro_tale/App/views/Home/others/view/birthchart.dart'; // Example import

class KundliScreen extends StatefulWidget {
  const KundliScreen({super.key});

  @override
  State<KundliScreen> createState() => _KundliScreenState();
}

class _KundliScreenState extends State<KundliScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController birthTimeController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive container
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(color: Colors.black.withOpacity(0.18)),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button + Title Row
                  Row(
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title centered
                      Expanded(
                        child: Text(
                          "Create Your Kundli",
                          textAlign: TextAlign.center, // Center the text within the Expanded
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Empty space to balance back button
                      SizedBox(width: 40), // same width as back button + padding
                    ],
                  ),

                  const SizedBox(height: 30),
                  Text(
                    "Enter your birth details to generate your personalized Kundli chart.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 30),

                  // Adaptive Form Container
                  Center(
                    child: Container(
                      width: screenWidth > 500 ? 500 : screenWidth * 0.95, // Responsive width
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff1A1A1F),
                        border: Border.all(color: const Color(0xFFDBC33F), width: 1.5),
                      ),
                      child: Column(
                        children: [
                          _buildInputField(nameController, "Full Name", Icons.person_outline),
                          _buildInputField(
                              birthDateController, "Date of Birth", Icons.calendar_today_outlined),
                          _buildInputField(
                              birthTimeController, "Time of Birth", Icons.access_time_outlined),
                          _buildInputField(
                              birthPlaceController, "Place of Birth", Icons.location_on_outlined),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _genderChip("Male", Icons.male),
                              const SizedBox(width: 10),
                              _genderChip("Female", Icons.female),
                            ],
                          ),
                          const SizedBox(height: 35),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffDBC33F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 14),
                            ),
                            onPressed: () {
                              if (nameController.text.isNotEmpty &&
                                  birthDateController.text.isNotEmpty &&
                                  birthTimeController.text.isNotEmpty &&
                                  birthPlaceController.text.isNotEmpty &&
                                  selectedGender != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const BirthChartScreen()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all details")),
                                );
                              }
                            },
                            child: Text(
                              "Generate Kundli",
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                          ),
                        ],
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

  Widget _buildInputField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: GoogleFonts.dmSans(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xffDBC33F)),
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: Colors.white70),
          filled: true,
          fillColor: Colors.black.withOpacity(0.4),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _genderChip(String gender, IconData icon) {
    final bool isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffDBC33F) : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.black : Colors.white),
            const SizedBox(width: 6),
            Text(gender,
                style: GoogleFonts.dmSans(color: isSelected ? Colors.black : Colors.white)),
          ],
        ),
      ),
    );
  }
}
