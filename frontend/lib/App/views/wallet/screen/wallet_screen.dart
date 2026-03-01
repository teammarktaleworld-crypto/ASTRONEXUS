import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../services/api_services/wallet_api.dart';
import '../../../Model/wallet_model.dart';

class WalletScreen extends StatefulWidget {
  final String userId;

  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Wallet? wallet;
  bool loading = true;
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadWallet();
  }

  Future<void> loadWallet() async {
    setState(() => loading = true);
    wallet = await WalletApi.getWallet(widget.userId);
    setState(() => loading = false);
  }

  Future<void> deposit() async {
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) return;
    await WalletApi.deposit(widget.userId, amount);
    await loadWallet();
    amountController.clear();
  }

  Future<void> withdraw() async {
    final amount = double.tryParse(amountController.text) ?? 0;
    if (amount <= 0) return;
    await WalletApi.withdraw(widget.userId, amount);
    await loadWallet();
    amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff393053),
      appBar: AppBar(
        backgroundColor: const Color(0xff050B1E),
        elevation: 0,
        title: Text(
          "Wallet",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loading ? _shimmer() : _content(),
    );
  }

  // ================= CONTENT =================

  Widget _content() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _balanceCard(),
          const SizedBox(height: 22),
          _amountField(),
          const SizedBox(height: 18),
          _buttons(),
          const SizedBox(height: 30),
          _sectionTitle("Payment Methods"),
          const SizedBox(height: 14),
          _paymentMethods(),
          const SizedBox(height: 30),
          _sectionTitle("Spending Overview"),
          const SizedBox(height: 14),
          _analyticsCards(),
        ],
      ),
    );
  }

  // ================= BALANCE CARD =================

  Widget _balanceCard() {
    return Container(



      padding: const EdgeInsets.all(22),
      decoration: _card(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xff393053),
              borderRadius: BorderRadius.circular(14),

            ),
            child: const Icon(
              LucideIcons.wallet,
              color: Color(0xFFDBC33F),
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available Balance",
                style: GoogleFonts.dmSans(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "₹ ${wallet!.balance.toStringAsFixed(2)}",
                style: GoogleFonts.dmSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= AMOUNT INPUT =================

  Widget _amountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _card(),
      child: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          icon: const Icon(
            LucideIcons.indianRupee,
            size: 18,
            color: Colors.white70,
          ),
          hintText: "Enter amount",
          hintStyle: GoogleFonts.dmSans(color: Colors.white38),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ================= BUTTONS =================

  Widget _buttons() {
    return Row(
      children: [
        Expanded(
          child: _button(
            text: "Add Money",
            icon: LucideIcons.plus,
            color: const Color(0xFF4CAF50),
            onTap: deposit,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _button(
            text: "Withdraw",
            icon: LucideIcons.minus,
            color: const Color(0xFFE53935),
            onTap: withdraw,
          ),
        ),
      ],
    );
  }

  Widget _button({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.dmSans(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PAYMENT METHODS =================

  Widget _paymentMethods() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _method("GPay", LucideIcons.smartphone),
        _method("UPI", LucideIcons.qrCode),
        _method("Card", LucideIcons.creditCard),
        _method("Bank", LucideIcons.building2),
      ],
    );
  }

  Widget _method(String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: _card(),
          child: Icon(icon, size: 22, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  // ================= ANALYTICS =================

  Widget _analyticsCards() {
    return Row(
      children: [
        Expanded(child: _statCard("Spent", "₹2,450", Colors.redAccent)),
        const SizedBox(width: 14),
        Expanded(child: _statCard("Added", "₹4,000", Colors.greenAccent)),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(color: Colors.white60),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SHIMMER =================

  Widget _shimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.white10,
      highlightColor: Colors.white24,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _box(120),
            const SizedBox(height: 18),
            _box(52),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _box(48)),
                const SizedBox(width: 14),
                Expanded(child: _box(48)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double h) => Container(
    height: h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
  );

  // ================= HELPERS =================

  BoxDecoration _card() => BoxDecoration(
    color: Color(0xff18122B),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white10),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }
}