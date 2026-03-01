import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

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

  Future<void> _navigateToAddAddress() async {
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
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Select Address",
          style: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Add Address",
            onPressed: _navigateToAddAddress,
            icon: const Icon(Icons.add_location_alt_rounded,
                color: Colors.amberAccent),
          ),
        ],
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: loading
                ? _shimmerLoader()
                : addresses.isEmpty
                ? _emptyState()
                : Column(
              children: [
                Expanded(child: _addressList()),
                _deliverHereButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SHIMMER =================
  Widget _shimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.white12,
        highlightColor: Colors.white24,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  // ================= LIST =================
  Widget _addressList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final addr = addresses[index];
        final isSelected = addr == selectedAddress;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: isSelected
                ? LinearGradient(
              colors: [Colors.amberAccent.withOpacity(0.25), Colors.amberAccent.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : LinearGradient(
              colors: [Colors.white10, Colors.white12],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isSelected ? Colors.amberAccent : Colors.white24,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => setState(() => selectedAddress = addr),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Selection Indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(top: 4),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.amberAccent,
                          width: 2,
                        ),
                        color: isSelected ? Colors.amberAccent : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.black,
                      )
                          : null,
                    ),

                    const SizedBox(width: 16),

                    /// Address Text
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: addr.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const TextSpan(text: "\n"),
                            TextSpan(
                              text: "${addr.street}, ${addr.city}\n",
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: "${addr.state} - ${addr.postalCode}",
                              style: const TextStyle(
                                color: Colors.amberAccent,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Delete
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _deleteAddress(addr.id),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          color: Colors.white38,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= CTA =================
  Widget _deliverHereButton() {
    final isEnabled = selectedAddress != null;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SizedBox(
          width: double.infinity, // Full-width button
          height: 56,
          child: Material(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isEnabled ? _confirmSelection : null,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isEnabled
                      ? const LinearGradient(
                    colors: [Colors.amberAccent, Colors.amberAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                      : LinearGradient(
                    colors: [Colors.grey.shade300, Colors.grey.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Deliver to this address",
                  style: GoogleFonts.dmSans(
                    color: isEnabled ? Colors.grey.shade900 : Colors.grey.shade500,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= EMPTY =================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_off, color: Colors.white38, size: 64),
          const SizedBox(height: 12),
          const Text(
            "No address found",
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _navigateToAddAddress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
            const Text("Add Address", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  // ================= BACKGROUND =================
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