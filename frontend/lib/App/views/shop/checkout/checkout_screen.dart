import 'dart:math';
import 'package:astro_tale/App/Model/cart_model.dart';
import 'package:astro_tale/App/Model/product_model.dart';
import 'package:astro_tale/App/views/shop/checkout/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../services/api_services/api_service.dart';
import '../../../../services/api_services/order_api.dart';
import '../../../../services/api_services/payment_api.dart';
import '../../../Model/address_model.dart';
import '../widgets/address_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductModel? product;
  final CartModel? cart;
  final String userToken;

  const CheckoutScreen({
    super.key,
    this.product,
    this.cart,
    required this.userToken,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? selectedAddress;
  bool loading = false;
  String paymentMethod = "UPI"; // default payment method

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;

    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xff050B1E),
        elevation: 0,
        title: Text(
          "Checkout",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: cart == null
                  ? Center(
                child: Text(
                  "Your cart is empty",
                  style: GoogleFonts.dmSans(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
              )
                  : Column(
                children: [
                  Expanded(
                    child: AddressWidget(
                      userToken: widget.userToken,
                      onAddressSelected: (addr) {
                        setState(() {
                          selectedAddress = addr;
                        });
                      },
                      selectedAddress: selectedAddress,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // PAYMENT METHOD SELECTOR
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Method",
                        style: GoogleFonts.dmSans(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xff18122B),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: paymentMethod,
                            isExpanded: true,
                            dropdownColor: const Color(0xff18122B),
                            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.white70),
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: "UPI",
                                child: Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet_outlined,
                                        color: Colors.greenAccent, size: 20),
                                    SizedBox(width: 10),
                                    Text("Online Payment"),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: "CASH",
                                child: Row(
                                  children: [
                                    Icon(Icons.payments_outlined,
                                        color: Colors.amberAccent, size: 20),
                                    SizedBox(width: 10),
                                    Text("Cash on Delivery"),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (val) {
                              setState(() {
                                paymentMethod = val!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedAddress == null ? null : () async {
                        setState(() => loading = true);

                        try {
                          // 1️⃣ Place order
                          final order = await OrderApi().placeOrder(
                            addressId: selectedAddress!.id,
                            paymentMethod: paymentMethod,
                          );

                          setState(() => loading = false);

                          if (order != null) {
                            if (paymentMethod == "UPI") {
                              // Online payment: go to payment screen
                              final payment = await PaymentApi().createPayment(order.totalAmount!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PaymentScreen(
                                    order: order,
                                    payment: payment,
                                    userToken: widget.userToken,
                                  ),
                                ),
                              );
                            } else {
                              // Cash on Delivery: show success dialog
                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xff393053), Color(0xff050B1E)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle_outline,
                                            color: Colors.greenAccent, size: 64),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Order Placed Successfully!",
                                          style: GoogleFonts.dmSans(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "You can pay on delivery. Thank you for shopping with us!",
                                          style: GoogleFonts.dmSans(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context); // close dialog
                                            Navigator.pop(context); // close dialog
                                            Navigator.pop(context); // close dialog
                                            Navigator.pop(context); // close dialog



                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.greenAccent,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            "Go to Shop",
                                            style: GoogleFonts.dmSans(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Failed to place order")),
                            );
                          }
                        } catch (e) {
                          setState(() => loading = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      },
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                        paymentMethod == "UPI" ? "Proceed to Payment" : "Place Order (Cash)",
                        style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )


                ],
              ),
            ),
          ),
        ],
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
