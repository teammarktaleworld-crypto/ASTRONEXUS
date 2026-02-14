import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  String gender = "Male";
  String? prediction;
  bool isLoading = false;

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xff3B3B98)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      timeController.text = pickedTime.format(context);
    }
  }

  void _getPrediction() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final body = {
        "name": nameController.text,
        "dob": dobController.text,
        "tob": timeController.text,
        "place": placeController.text,
        "gender": gender
      };

      try {
        final response = await http.post(
          Uri.parse("http://YOUR_BACKEND_IP:5000/api/prediction"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        final data = jsonDecode(response.body);

        setState(() {
          isLoading = false;
          prediction = data["prediction"];  // backend se milega
        });
      } catch (e) {
        setState(() {
          isLoading = false;
          prediction = "Something went wrong: $e";
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Astro Prediction",
          style: GoogleFonts.dmSans(
            color: const Color(0xff1D1442),
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xff3B3B98)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffE9E7FD), Color(0xffDAD8FB), Color(0xffF5F3FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -80,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x403B3B98),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x403B3B98),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Reveal Your Stars ✨",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: const Color(0xff1D1442),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your birth details to discover what the cosmos has planned for you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Form card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.85),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInputField(
                            label: "Full Name",
                            controller: nameController,
                            icon: Icons.person_outline,
                          ),
                          _buildInputField(
                            label: "Date of Birth",
                            controller: dobController,
                            icon: Icons.calendar_today_outlined,
                            onTap: _selectDate,
                          ),
                          _buildInputField(
                            label: "Time of Birth",
                            controller: timeController,
                            icon: Icons.access_time_outlined,
                            onTap: _selectTime,
                          ),
                          _buildInputField(
                            label: "Place of Birth",
                            controller: placeController,
                            icon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 20),

                          // Gender Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _genderChip("Male", Icons.male),
                              const SizedBox(width: 10),
                              _genderChip("Female", Icons.female),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // Prediction Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff4A4A77),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 60, vertical: 14),
                              elevation: 6,
                            ),
                            onPressed: isLoading ? null : _getPrediction,
                            child: isLoading
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : Text(
                              "Show Prediction",
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Prediction Box
                    if (prediction != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(22),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff3B3B98).withOpacity(0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          prediction!,
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontSize: 15,
                            height: 1.6,
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
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: onTap != null,
        onTap: onTap,
        validator: (value) =>
        value == null || value.isEmpty ? "Please enter $label" : null,
        style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xff3B3B98)),
          labelText: label,
          labelStyle: GoogleFonts.dmSans(color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _genderChip(String genderText, IconData icon) {
    bool isSelected = gender == genderText;
    return GestureDetector(
      onTap: () => setState(() => gender = genderText),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff4A4A77) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color:
            isSelected ? const Color(0xff4A4A77) : Colors.grey.shade300,
          ),
          boxShadow: [
            if (isSelected)
              const BoxShadow(
                color: Color(0x403B3B98),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18,
                color: isSelected ? Colors.white : const Color(0xff3B3B98)),
            const SizedBox(width: 6),
            Text(
              genderText,
              style: GoogleFonts.dmSans(
                color: isSelected ? Colors.white : const Color(0xff1D1442),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
