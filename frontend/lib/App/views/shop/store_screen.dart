import 'dart:async';
import 'dart:ui';

import 'package:astro_tale/App/controller/Auth_Controller.dart';
import 'package:astro_tale/App/views/shop/product/product_details_screen.dart';
import 'package:astro_tale/App/views/shop/widgets/search_field.dart';
import 'package:astro_tale/util/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:astro_tale/App/views/shop/widgets/category_chip.dart';
import 'package:astro_tale/App/views/shop/widgets/loading_placeholder.dart';
import 'package:astro_tale/App/views/shop/widgets/product_card.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart'; // <-- skeleton import

import '../../../services/api_services/store_api.dart';
import '../../Model/category_model.dart';
import '../../Model/product_model.dart';

import 'cart/cart_screen.dart';
import 'orders/my_orders_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final StoreApi _storeApi = StoreApi();
  final TextEditingController _searchController = TextEditingController();

  bool isSearching = false;
  bool loading = true;

  List<ProductModel> products = [];
  List<ProductModel> filteredProducts = [];
  List<CategoryModel> categories = [];

  int selectedCategoryIndex = 0;

  // ================= BANNER ANIMATION =================
  final PageController _bannerController = PageController();
  Timer? _bannerTimer;
  int _currentBanner = 0;

  final List<String> banners = [
    AppConstant.banner_shop1,
    AppConstant.banner_shop2,
    AppConstant.banner_shop1,
  ];

  @override
  void initState() {
    super.initState();
    _fetchStoreData();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        _currentBanner = (_currentBanner + 1) % banners.length;
        _bannerController.animateToPage(
          _currentBanner,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ================= FETCH =================

  Future<void> _fetchStoreData() async {
    setState(() => loading = true);
    try {
      final fetchedCategories = await _storeApi.getCategories();

      categories = [
        CategoryModel(
          id: "",
          name: "All",
          slug: "all",
          isActive: true,
          order: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        ...fetchedCategories,
      ];

      products = await _storeApi.getProducts();
    } catch (e) {
      debugPrint("Store fetch error: $e");
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _fetchProductsByCategory(String? categoryId) async {
    setState(() => loading = true);
    try {
      products = await _storeApi.getProducts(categoryId: categoryId);
      filteredProducts.clear();
      isSearching = false;
      _searchController.clear();
    } catch (e) {
      debugPrint("Category fetch error: $e");
    }
    if (mounted) setState(() => loading = false);
  }

  // ================= SEARCH =================

  void _onSearchChanged(String value) {
    if (value.trim().isEmpty) {
      setState(() {
        isSearching = false;
        filteredProducts.clear();
      });
      return;
    }

    setState(() {
      isSearching = true;
      filteredProducts = products
          .where((p) => p.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Shop",
          style: GoogleFonts.dmSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyOrdersScreen()),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _background(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  loading
                      ? SkeletonItem(
                    child: SkeletonParagraph(
                      style: SkeletonParagraphStyle(
                        lines: 1,
                        spacing: 12,
                        lineStyle: SkeletonLineStyle(
                          height: 160,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  )
                      : _bannerSlider(),
                  const SizedBox(height: 16),
                  SearchField(
                    controller: _searchController,
                    isSearching: isSearching,
                    onChanged: _onSearchChanged,
                    onClear: () {
                      _searchController.clear();
                      _onSearchChanged("");
                    },
                  ),
                  const SizedBox(height: 16),
                  loading ? _categorySkeleton() : _categoryChips(),
                  const SizedBox(height: 20),
                  _productGrid(),
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

  // ================= BANNER UI =================

  Widget _bannerSlider() {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: _bannerController,
        itemCount: banners.length,
        itemBuilder: (_, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              banners[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  // ================= CATEGORY SKELETON =================

  Widget _categorySkeleton() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, __) => SkeletonItem(
          child: SkeletonLine(
            style: SkeletonLineStyle(
              width: 80,
              height: 40,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  // ================= CATEGORY =================

  Widget _categoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CategoryChip(
              label: category.name,
              isSelected: index == selectedCategoryIndex,
              onTap: () {
                setState(() => selectedCategoryIndex = index);
                final id = category.id.isEmpty ? null : category.id;
                _fetchProductsByCategory(id);
              },
            ),
          );
        },
      ),
    );
  }

  // ================= PRODUCTS =================

  // ================= PRODUCTS =================

  Widget _productGrid() {
    final list = isSearching ? filteredProducts : products;

    if (loading) {
      // Show skeleton cards
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: 4,
        itemBuilder: (_, __) => SkeletonItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 150,

                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 8),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 14,
                  width: 100,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 4),
              SkeletonLine(
                style: SkeletonLineStyle(
                  height: 14,
                  width: 60,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "No products found",
            style: GoogleFonts.poppins(color: Colors.white60),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: list.length,
      itemBuilder: (_, index) {
        final product = list[index];
        return ProductCard(
          name: product.name,
          imageUrl: product.images.isNotEmpty
              ? product.images.first
              : "https://via.placeholder.com/200",
          price: product.price,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailsScreen(productId: product.id.trim()),
              ),
            );
          },
        );
      },
    );
  }

}
