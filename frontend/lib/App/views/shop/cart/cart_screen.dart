import 'dart:ui';
import 'package:astro_tale/App/controller/Auth_Controller.dart';
import 'package:astro_tale/App/views/shop/checkout/address_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../services/api_services/ cart_api.dart';
import '../../../Model/address_model.dart';
import '../../../Model/cart_model.dart';
import '../checkout/checkout_screen.dart';
import '../widgets/discount_widgets.dart';
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

  String? appliedCode;
  double discountedTotal = 0.0;
  bool discountApplied = false;
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

    final index =
    cart!.items.indexWhere((item) => item.productId == productId);

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
      await _loadCart();
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
                ? _shimmerLoader()
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
                        return _cartItemCard(cart!.items[index]);
                      },
                    ),
                  ),
                  ApplyDiscountWidget(
                    cartTotal: cart!.subtotal.toDouble(),
                    onDiscountApplied: (finalAmount) {
                      setState(() {
                        discountedTotal = finalAmount;
                        discountApplied = true;
                      });
                    },
                  ),

                  const SizedBox(height: 12),
                  CartSummary(
                    subtotal: cart!.subtotal.toDouble(),
                    discount: discountApplied
                        ? cart!.subtotal.toDouble() - discountedTotal
                        : 0.0,
                    total: discountApplied
                        ? discountedTotal
                        : cart!.subtotal.toDouble(),
                    onCheckout: () async {
                      final Address? selectedAddress =
                      await Navigator.push<Address>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AddressSelector(token: AuthController.token),
                        ),
                      );

                      if (selectedAddress == null) return;

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

  // ================= SHIMMER LOADER =================

  Widget _shimmerLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: 4,
        itemBuilder: (_, __) => _shimmerCartItem(),
      ),
    );
  }

  Widget _shimmerCartItem() {
    return Shimmer.fromColors(
      baseColor: Colors.white12,
      highlightColor: Colors.white24,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 16, width: double.infinity),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 100),
                  const SizedBox(height: 12),
                  Container(height: 28, width: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CART ITEM =================

  Widget _cartItemCard(CartItemModel item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.45),
              blurRadius: 22,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xff050B1E).withOpacity(0.6),

                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.amberAccent.withOpacity(0.35),
                  width: 1.2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Product Image
                  _productImage(item.image),

                  const SizedBox(width: 14),

                  /// Product Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "₹${item.price.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 10),

                        _quantityControls(item),
                      ],
                    ),
                  ),

                  /// Delete Button
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _removeItem(item.productId),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white.withOpacity(0.45),
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

  Widget _productImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url.isNotEmpty ? url : "https://via.placeholder.com/80",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _quantityControls(CartItemModel item) {
    return Row(
      children: [
        _iconButton(Icons.remove,
                () => _updateQuantity(item.productId, item.quantity - 1)),
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
        _iconButton(Icons.add,
                () => _updateQuantity(item.productId, item.quantity + 1)),
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