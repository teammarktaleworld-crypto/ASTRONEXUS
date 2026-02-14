// language: dart
import 'dart:ui';
import 'package:astro_tale/App/views/shop/checkout/address_selector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../services/api_services/ cart_api.dart';
import '../../../../services/api_services/api_service.dart';
import '../../../Model/cart_model.dart';
import '../../../Model/product_model.dart';
import '../../../controller/Auth_Controller.dart';
import '../../../controller/feedback_conroller.dart';
import '../../feedback/screen/feedback_screen.dart';
import '../cart/cart_screen.dart';
import '../checkout/checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ApiService _apiService = ApiService();
  final CartApi _cartApi = CartApi();

  // typed keys so we can call \`loadFeedbacks()\` safely
  final GlobalKey<FeedbackScreenState> feedbackListKey = GlobalKey<FeedbackScreenState>();
  final GlobalKey<FeedbackScreenState> feedbackSheetKey = GlobalKey<FeedbackScreenState>();

  ProductModel? product;
  CartModel? cart;
  bool loading = true;
  int cartCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
    _loadCart();
  }

  // ================= FETCH CART =================
  Future<void> _loadCart() async {
    try {
      final fetchedCart = await _cartApi.getCart();
      if (mounted) {
        setState(() {
          cart = fetchedCart;
          cartCount = fetchedCart.items.fold(
            0,
                (sum, item) => sum + item.quantity,
          );
        });
      }
    } catch (e) {
      debugPrint("Cart load error: $e");
    }
  }

  // ================= FETCH PRODUCT =================
  Future<void> _fetchProduct() async {
    try {
      final fetchedProduct =
      await _apiService.getProductById(widget.productId.trim());

      if (mounted) {
        setState(() {
          product = fetchedProduct;
          loading = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  // ================= ADD TO CART =================
  Future<void> _addToCart() async {
    if (product == null || product!.stock <= 0) return;

    if (!AuthController.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to add items to cart")),
      );
      return;
    }

    try {
      debugPrint("Adding product to cart: ${product!.id}, quantity: 1");
      await _cartApi.addToCart(product!.id, 1);
      await _loadCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added to cart")),
        );
      }
    } catch (e) {
      debugPrint("Add to cart failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add to cart: $e")),
        );
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.amberAccent,
        icon: const Icon(Icons.rate_review, color: Colors.black),
        label: const Text("Review", style: TextStyle(color: Colors.black)),
        onPressed: () {
          if (!AuthController.isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please login to write a review")),
            );
            return;
          }
          _openReviewBottomSheet();
        },
      ),
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('AstroNexus', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  ).then((_) => _loadCart());
                },
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                    const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      cartCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: loading
          ? Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Colors.white,
          size: 50,
        ),
      )
          : product == null
          ? _error()
          : _content(),
    );
  }

  Widget _content() {
    return Stack(
      children: [
        _background(),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imageSlider(),
                const SizedBox(height: 20),
                _infoCard(),
                const SizedBox(height: 24),
                _actionButtons(),
                const SizedBox(height: 32),
                Text(
                  "Customer Reviews",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: FeedbackScreen(
                    key: feedbackListKey,
                    productId: product!.id,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _background() => Container(
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

  Widget _imageSlider() {
    final images = product!.images.isNotEmpty
        ? product!.images
        : ["https://via.placeholder.com/400"];
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 280,
        child: PageView.builder(
          itemCount: images.length,
          itemBuilder: (_, i) => Image.network(
            images[i],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
                color: Colors.white10,
                child:
                const Icon(Icons.image_not_supported, size: 60)),
          ),
        ),
      ),
    );
  }

  Widget _infoCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product!.name,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Divider(),
              Text(product!.description ?? "No description available",
                  style:
                  GoogleFonts.poppins(color: Colors.white70, height: 1.5)),
              const SizedBox(height: 8),
              Text("₹${product!.price}",
                  style: GoogleFonts.poppins(
                      color: Colors.amberAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _badges(),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badges() {
    return Wrap(
      spacing: 8,
      children: [
        _chip(product!.astrologyType.name.toUpperCase()),
        _chip(product!.deliveryType.name.toUpperCase()),
        _chip(
          product!.stock > 0 ? "IN STOCK" : "OUT OF STOCK",
          color: product!.stock > 0 ? Colors.green : Colors.red,
        ),
      ],
    );
  }

  Widget _chip(String label, {Color color = Colors.black87}) {
    return Chip(
      backgroundColor: color.withOpacity(.2),
      label:
      Text(label, style: GoogleFonts.poppins(color: color, fontSize: 12)),
    );
  }

  Widget _actionButtons() {
    final disabled = product!.stock <= 0;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: disabled ? null : _addToCart,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child:
            Text("Add to Cart", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: disabled
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amberAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text("Buy Now",
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  void _openReviewBottomSheet() {
    double userRating = 0;
    final reviewController = TextEditingController();
    bool submitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom:
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text("Rate this product",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    Center(
                      child: RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        itemCount: 5,
                        itemSize: 36,
                        glow: true,
                        itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) {
                          setModalState(() => userRating = rating);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Share your experience...",
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    submitting
                        ? Center(
                      child:
                      LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.amberAccent,
                        size: 40,
                      ),
                    )
                        : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (userRating == 0 ||
                              reviewController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                content: Text(
                                    "Please add rating & review")));
                            return;
                          }

                          setModalState(() => submitting = true);

                          try {
                            await FeedbackController().addFeedback(
                              product!.id,
                              userRating,
                              reviewController.text.trim(),
                            );

                            // Close the input sheet
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }

                            // Refresh inline review list
                            feedbackListKey.currentState?.loadFeedbacks();

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                content: Text(
                                    "Review submitted successfully")));

                            // Open full reviews sheet so user sees the new review
                            _openReviewsListSheet();
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text("Failed: $e")));
                          } finally {
                            setModalState(() => submitting = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amberAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14)),
                        ),
                        child: Text("Submit Review",
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // glass-style sheet showing the full reviews list
  void _openReviewsListSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(30)),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.78,
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text("Reviews",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: FeedbackScreen(
                      key: feedbackSheetKey,
                      productId: product!.id,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _error() =>
      Center(child: Text("Product not found", style: GoogleFonts.poppins(color: Colors.white60)));
}
