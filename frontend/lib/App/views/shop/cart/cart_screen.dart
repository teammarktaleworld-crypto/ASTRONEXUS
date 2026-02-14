import 'dart:ui';
import 'package:astro_tale/App/controller/Auth_Controller.dart';
import 'package:astro_tale/App/views/shop/checkout/address_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/api_services/ cart_api.dart';
import '../../../Model/address_model.dart';
import '../../../Model/cart_model.dart';
import '../checkout/checkout_screen.dart';
import 'cart_item_tile.dart';
import 'cart_summary.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartApi _cartApi = CartApi();

  CartModel? cart;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => loading = true);
    try {
      cart = await _cartApi.getCart();
    } catch (e) {
      debugPrint("Cart load error: $e");
    }
    setState(() => loading = false);
  }

  Future<void> _updateQuantity(String productId, int quantity) async {
    if (quantity < 1) return;

    // Optimistic UI update
    final index = cart!.items.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      setState(() {
        cart!.items[index] = CartItemModel(
          productId: cart!.items[index].productId,
          name: cart!.items[index].name,
          price: cart!.items[index].price,
          image: cart!.items[index].image,
          quantity: quantity,
        );
      });
    }

    try {
      await _cartApi.updateCartItem(productId, quantity);
      await _loadCart(); // Refresh from server
    } catch (e) {
      debugPrint("Update quantity failed: $e");
    }
  }


  Future<void> _removeItem(String productId) async {
    await _cartApi.removeCartItem(productId);
    await _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Your Cart",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : cart == null || cart!.items.isEmpty
                ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(color: Colors.white70),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart!.items.length,
                      itemBuilder: (context, index) {
                        final item = cart!.items[index];
                        return _cartItemCard(item);
                      },
                    ),
                  ),
                  CartSummary(
                    subtotal: cart!.subtotal.toDouble(),
                    discount: cart!.discount.toDouble(),
                    total: cart!.total.toDouble(),
                    onCheckout: () async {
                      final Address? selectedAddress = await Navigator.push<Address>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddressSelector(token: AuthController.token),
                        ),
                      );

                      // User may press back without selecting
                      if (selectedAddress == null) return;

                      // Navigate to checkout with selected address
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(
                            cart: cart!,
                            userToken: AuthController.token,
                          ),
                        ),
                      );
                    },
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

  Widget _cartItemCard(CartItemModel item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _productImage(item.image),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    const SizedBox(height: 6),
                    Text("₹${item.price.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _quantityControls(item),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _removeItem(item.productId),
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url.isNotEmpty
            ? url
            : "https://via.placeholder.com/80", // fallback
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _quantityControls(CartItemModel item) {
    return Row(
      children: [
        _iconButton(Icons.remove, () => _updateQuantity(item.productId, item.quantity - 1)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.quantity.toString(),
            style: GoogleFonts.poppins(color: Colors.white),
          ),
        ),
        _iconButton(Icons.add, () => _updateQuantity(item.productId, item.quantity + 1)),
      ],
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
