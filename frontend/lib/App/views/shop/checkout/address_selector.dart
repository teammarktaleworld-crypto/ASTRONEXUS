import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_services/adress_api.dart';
import '../../../Model/address_model.dart';
import 'add_address_screen.dart';

class AddressSelector extends StatefulWidget {
  final String token;

  const AddressSelector({super.key, required this.token});

  @override
  State<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends State<AddressSelector> {
  final AddressApi _api = AddressApi();
  List<Address> addresses = [];
  bool loading = true;
  Address? selectedAddress;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    setState(() => loading = true);
    try {
      addresses = await _api.getUserAddresses(token: widget.token);
      if (addresses.isNotEmpty) {
        selectedAddress = addresses.firstWhere(
              (a) => a.isDefault,
          orElse: () => addresses.first,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    setState(() => loading = false);
  }

  Future<void> _deleteAddress(String id) async {
    await _api.deleteAddress(token: widget.token, addressId: id);
    _loadAddresses();
  }

  void _confirmSelection() {
    if (selectedAddress != null) {
      Navigator.pop(context, selectedAddress);
    }
  }

  void _navigateToAddAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddAddressScreen(token: widget.token),
      ),
    );
    _loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final horizontalPadding = mq.size.width * 0.04; // 4% of width
    final verticalPadding = mq.size.height * 0.02; // 2% of height

    return Scaffold(
      backgroundColor: Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Color(0xff050B1E),
        elevation: 0,
        title: Text(
          "Select Address",
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAddress,
        backgroundColor: Colors.amberAccent,
        child: const Icon(Icons.add, color: Colors.black),
        tooltip: "Add Address",
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: Colors.amberAccent))
                : addresses.isEmpty
                ? _emptyState(horizontalPadding, verticalPadding)
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding),
                  child: Text(
                    "Select Delivery Address",
                    style: GoogleFonts.dmSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      final addr = addresses[index];
                      final isSelected = addr == selectedAddress;

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: verticalPadding / 2),
                        child: Material(
                          color: isSelected
                              ? Colors.amberAccent.withOpacity(0.2)
                              : const Color(0xff1A1F38),
                          borderRadius: BorderRadius.circular(16),
                          elevation: isSelected ? 4 : 2,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => setState(() => selectedAddress = addr),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                children: [
                                  Radio<Address>(
                                    value: addr,
                                    groupValue: selectedAddress,
                                    onChanged: (val) =>
                                        setState(() => selectedAddress = val),
                                    activeColor: Colors.amberAccent,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          addr.fullName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${addr.street}, ${addr.city}, ${addr.state} - ${addr.postalCode}",
                                          style: const TextStyle(
                                              color: Colors.white70, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () => _deleteAddress(addr.id),
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6.0),
                                      child: Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: ElevatedButton(
                    onPressed: _confirmSelection,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Deliver Here",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: verticalPadding + 16), // extra space for FAB
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(double hPadding, double vPadding) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: hPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No address found",
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: vPadding),
            ElevatedButton(
              onPressed: _navigateToAddAddress,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Add Address", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
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
