import 'package:astro_tale/App/controller/Auth_Controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:astro_tale/App/views/subscription/views/subscription_screen.dart';
import 'package:astro_tale/App/views/wallet/screen/wallet_screen.dart';
import '../../shop/orders/my_orders_screen.dart';
import '../../tracking/screen/order_tracking_screen.dart';
import '../../wishlist/screen/wishlist_screen.dart';
import '../others/birthdetails_screen/birth_details_screen.dart';

class MenuSection extends StatelessWidget {
  const MenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuCard(
          title: "Personal Details",
          icon: LucideIcons.user,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BirthDetailsScreen()),
            );
          },
        ),

        const SizedBox(height: 12),

        _MenuCard(
          title: "Birth Details / Kundli",
          icon: LucideIcons.cake,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BirthDetailsScreen()),
            );
          },
        ),

        const SizedBox(height: 12),

        _MenuCard(
          title: "Wishlist",
          icon: LucideIcons.heart,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WishlistScreen()),
            );
          },
        ),

        const SizedBox(height: 12),

        _MenuCard(
          title: "My Orders",
          icon: LucideIcons.package,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
            );
          },
        ),


        const SizedBox(height: 12),

        /// ✅ WALLET (FIXED)
        _MenuCard(
          title: "Wallet & Payments",
          icon: LucideIcons.wallet,
          onTap: () {
            final userId = AuthController.userId;

            if (userId == null || userId.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please login again"),
                ),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WalletScreen(userId: userId),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        _MenuCard(
          title: "Subscriptions",
          icon: LucideIcons.crown,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SubscriptionPage()),
            );
          },
        ),
      ],
    );
  }
}

/*────────────────── MENU CARD ──────────────────*/
class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            /// ICON
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.black87,
              ),
            ),

            const SizedBox(width: 14),

            /// TITLE
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.dmSans(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            /// ARROW
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}