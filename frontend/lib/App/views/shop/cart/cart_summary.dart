import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../util/formatters.dart';

class CartSummary extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double total;
  final VoidCallback? onCheckout;

  const CartSummary({
    super.key,
    required this.subtotal,
    required this.discount,
    required this.total,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 24,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.amberAccent.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _row("Subtotal", subtotal),
                  const SizedBox(height: 8),
                  _row(
                    "Discount",
                    discount,
                    valueColor: Colors.redAccent.withOpacity(0.85),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 10),
                  _row("Total", total, isTotal: true),
                  const SizedBox(height: 18),

                  /// Checkout Button
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onCheckout,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "Checkout",
                          style: GoogleFonts.dmSans(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(
      String label,
      double value, {
        bool isTotal = false,
        Color? valueColor,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.dmSans(
            color: Colors.white.withOpacity(isTotal ? 1 : 0.75),
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
        Text(
          Formatters.price(value),
          style: GoogleFonts.dmSans(
            color: valueColor ??
                (isTotal ? Colors.amberAccent : Colors.white70),
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTotal ? 18 : 14,
          ),
        ),
      ],
    );
  }
}