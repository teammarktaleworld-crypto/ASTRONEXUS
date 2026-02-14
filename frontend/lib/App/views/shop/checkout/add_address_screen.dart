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
      labelStyle: TextStyle(color: Colors.white70, fontFamily: GoogleFonts.dmSans().fontFamily),
      filled: true,
      fillColor: const Color(0xff1A1F38),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white24, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff050B1E),
      appBar: AppBar(
        title: Text(
          widget.existing == null ? "Add Address" : "Edit Address",
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        backgroundColor: Colors.amberAccent,
        child: loading
            ? const CircularProgressIndicator(color: Colors.black)
            : const Icon(Icons.check, color: Colors.black),
        tooltip: "Save Address",
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
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: isDefault,
                      onChanged: (v) => setState(() => isDefault = v),
                      title: const Text("Set as default address",
                          style: TextStyle(color: Colors.white70)),
                      activeColor: Colors.amberAccent,
                    ),
                    const SizedBox(height: 70), // space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        decoration: _dec(label),
        style: TextStyle(color: Colors.white, fontFamily: GoogleFonts.dmSans().fontFamily),
        validator: (v) => v == null || v.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff393053),
            Color(0xff393053),
            Color(0xff050B1E),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
