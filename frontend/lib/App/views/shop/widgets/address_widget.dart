import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_services/api_service.dart';
import '../../../Model/address_model.dart';

class AddressWidget extends StatefulWidget {
  final String userToken;
  final Function(Address) onAddressSelected;
  final Address? selectedAddress;

  const AddressWidget({
    super.key,
    required this.userToken,
    required this.onAddressSelected,
    this.selectedAddress,
  });

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final ApiService _apiService = ApiService();
  late Future<List<Address>> _addressesFuture;
  Address? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.selectedAddress;
    _loadAddresses();
  }

  void _loadAddresses() {
    _addressesFuture =
        _apiService.getUserAddresses(token: widget.userToken);
  }

  // ===================== ADDRESS FORM =====================
  void _showAddressForm({Address? address}) {
    final formKey = GlobalKey<FormState>();
    final fullNameController =
    TextEditingController(text: address?.fullName ?? '');
    final phoneController =
    TextEditingController(text: address?.phone ?? '');
    final streetController =
    TextEditingController(text: address?.street ?? '');
    final cityController =
    TextEditingController(text: address?.city ?? '');
    final stateController =
    TextEditingController(text: address?.state ?? '');
    final countryController =
    TextEditingController(text: address?.country ?? '');
    final postalCodeController =
    TextEditingController(text: address?.postalCode ?? '');

    bool isDefault = address?.isDefault ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xff18122B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 4,
                          width: 40,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        address == null ? "Add New Address" : "Edit Address",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildTextField(fullNameController, "Full Name", Icons.person),
                      _buildTextField(phoneController, "Phone", Icons.phone),
                      _buildTextField(streetController, "Street", Icons.location_on),
                      _buildTextField(cityController, "City", Icons.location_city),
                      _buildTextField(stateController, "State", Icons.map),
                      _buildTextField(countryController, "Country", Icons.flag),
                      _buildTextField(postalCodeController, "Postal Code", Icons.mail),
                      Row(
                        children: [
                          Checkbox(
                            value: isDefault,
                            onChanged: (val) =>
                                setModalState(() => isDefault = val ?? false),
                            activeColor: Colors.amberAccent,
                          ),
                          Text("Set as default",
                              style: GoogleFonts.poppins(color: Colors.white70)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amberAccent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            if (!formKey.currentState!.validate()) return;

                            final newAddress = Address(
                              id: address?.id ?? "",
                              userId: "",
                              fullName: fullNameController.text,
                              phone: phoneController.text,
                              street: streetController.text,
                              city: cityController.text,
                              state: stateController.text,
                              country: countryController.text,
                              postalCode: postalCodeController.text,
                              isDefault: isDefault,
                            );

                            try {
                              if (address == null) {
                                await _apiService.addAddress(
                                    token: widget.userToken, address: newAddress);
                              } else {
                                await _apiService.updateAddress(
                                    token: widget.userToken, address: newAddress);
                              }
                              Navigator.pop(context);
                              setState(_loadAddresses);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          },
                          child: Text(
                            address == null ? "Save Address" : "Update Address",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xff393053),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (val) => val == null || val.isEmpty ? "Required" : null,
      ),
    );
  }

  void _deleteAddress(String id) async {
    await _apiService.deleteAddress(token: widget.userToken, addressId: id);
    setState(_loadAddresses);
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Address>>(
      future: _addressesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.amberAccent));
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Error loading addresses",
                style: GoogleFonts.poppins(color: Colors.white70)),
          );
        }

        final addresses = snapshot.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Delivery Address",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final addr = addresses[index];
                  final isSelected = _selectedAddress?.id == addr.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAddress = addr;
                        widget.onAddressSelected(addr);
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xff18122B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? Colors.amberAccent
                              : Colors.white10,
                          width: 1.4,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: isSelected
                                      ? Colors.amberAccent
                                      : Colors.white54),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(addr.fullName,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              if (addr.isDefault)
                                const Icon(Icons.check_circle,
                                    color: Colors.greenAccent, size: 18),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${addr.street}, ${addr.city}, ${addr.state}",
                            style: GoogleFonts.poppins(
                                color: Colors.white70, fontSize: 13),
                          ),
                          Text(
                            "${addr.country} - ${addr.postalCode}",
                            style: GoogleFonts.poppins(
                                color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded,
                                    color: Colors.amberAccent),
                                onPressed: () => _showAddressForm(address: addr),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_rounded,
                                    color: Colors.redAccent),
                                onPressed: () => _deleteAddress(addr.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.amberAccent),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _showAddressForm(),
                icon: const Icon(Icons.add_location_alt_rounded,
                    color: Colors.amberAccent),
                label: Text("Add New Address",
                    style: GoogleFonts.poppins(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.w600)),
              ),
            )
          ],
        );
      },
    );
  }
}
