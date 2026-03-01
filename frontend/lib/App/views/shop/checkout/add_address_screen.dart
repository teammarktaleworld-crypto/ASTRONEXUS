import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/api_services/adress_api.dart';
import '../../../Model/address_model.dart';

class AddAddressScreen extends StatefulWidget {
  final String token;
  final Address? existing;

  const AddAddressScreen({super.key, required this.token, this.existing});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final AddressApi _api = AddressApi();

  late TextEditingController fullName;
  late TextEditingController phone;
  late TextEditingController street;
  late TextEditingController city;
  late TextEditingController state;
  late TextEditingController country;
  late TextEditingController postalCode;
  bool isDefault = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final a = widget.existing;
    fullName = TextEditingController(text: a?.fullName);
    phone = TextEditingController(text: a?.phone);
    street = TextEditingController(text: a?.street);
    city = TextEditingController(text: a?.city);
    state = TextEditingController(text: a?.state);
    country = TextEditingController(text: a?.country ?? "India");
    postalCode = TextEditingController(text: a?.postalCode);
    isDefault = a?.isDefault ?? false;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final address = Address(
      id: widget.existing?.id ?? "",
      userId: "",
      fullName: fullName.text,
      phone: phone.text,
      street: street.text,
      city: city.text,
      state: state.text,
      country: country.text,
      postalCode: postalCode.text,
      isDefault: isDefault,
    );

    try {
      if (widget.existing == null) {
        await _api.addAddress(token: widget.token, address: address);
      } else {
        await _api.updateAddress(token: widget.token, address: address);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() => loading = false);
  }

  InputDecoration _dec(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.dmSans(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white24, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.existing == null ? "Add Address" : "Edit Address",
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),

      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _field(fullName, "Full Name"),
                    _field(phone, "Phone"),
                    _field(street, "Street"),
                    _field(city, "City"),
                    _field(state, "State"),
                    _field(country, "Country"),
                    _field(postalCode, "Postal Code"),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: SwitchListTile(
                        value: isDefault,
                        onChanged: (v) => setState(() => isDefault = v),
                        title: const Text(
                          "Set as default address",
                          style: TextStyle(color: Colors.white70),
                        ),
                        activeColor: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: _saveButton(),
                    ),],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TweenAnimationBuilder<Color?>(
        duration: const Duration(milliseconds: 300),
        tween: ColorTween(
          begin: Colors.white24.withOpacity(0.05),
          end: Colors.white24.withOpacity(0.05),
        ),
        builder: (context, color, child) {
          return Focus(
            onFocusChange: (hasFocus) => setState(() {}),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.02),
                    Colors.white.withOpacity(0.05)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: TextFormField(
                    controller: controller,
                    style: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (v) =>
                    v == null || v.isEmpty ? "Required" : null,
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: GoogleFonts.dmSans(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.white24,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.amberAccent,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: _save,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // pill shape
          gradient: const LinearGradient(
            colors: [Color(0xffFFD54F), Color(0xffFFC107)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: loading
            ? const CircularProgressIndicator(color: Colors.black)
            : Text(
          "Save Address",
          style: GoogleFonts.dmSans(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff393053), Color(0xff393053), Color(0xff050B1E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}