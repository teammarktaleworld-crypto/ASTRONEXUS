import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../services/api_services/wishlist_service.dart';
import '../../../Model/wishlist_model.dart';
import '../../../controller/Auth_Controller.dart';
import '../../shop/product/product_details_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late WishlistService _service;
  late Future<WishlistModel> _wishlistFuture;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _service = WishlistService(token: AuthController.token);
    _wishlistFuture = _service.getWishlist();
  }



  Future<void> _removeItem(String productId) async {
    setState(() => _loading = true);
    try {
      await _service.removeProduct(productId);
      setState(() => _wishlistFuture = _service.getWishlist()); // refresh
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openDetails(String productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(productId: productId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Wishlist",
          style: GoogleFonts.dmSans(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          _background(),
          FutureBuilder<WishlistModel>(
            future: _wishlistFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || _loading) {
                return _shimmerGrid();
              }

              if (!snapshot.hasData || snapshot.data!.products.isEmpty) {
                return Center(
                  child: Text(
                    "Your wishlist is empty",
                    style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 16),
                  ),
                );
              }

              final products = snapshot.data!.products;

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemBuilder: (_, index) => _wishlistCard(products[index]),
              );
            },
          ),
        ],
      ),
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

  Widget _wishlistCard(Product product) {
    final image = product.images.isNotEmpty ? product.images.first : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openDetails(product.id),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: image != null
                        ? Image.network(image, height: 180, width: double.infinity, fit: BoxFit.cover)
                        : Container(
                      height: 180,
                      color: Colors.white10,
                      child: const Icon(Icons.image, color: Colors.white30),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "₹${product.price}",
                        style: GoogleFonts.dmSans(color: Colors.amberAccent, fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _removeItem(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.white10,
        highlightColor: Colors.white24,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white10),
        ),
      ),
    );
  }
}