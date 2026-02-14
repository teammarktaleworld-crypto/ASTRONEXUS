import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../App/Model/order_model.dart';
import '../invoice/pdf_invoice_screen.dart';
import 'order_status_tile.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  int getStatusIndex(String status) {
    switch (status.toLowerCase()) {
      case "placed":
        return 0;
      case "shipped":
        return 1;
      case "delivered":
        return 2;
      default:
        return 0;
    }
  }

  String formatDate(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "delivered":
        return Colors.green;
      case "shipped":
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completedIndex = getStatusIndex(order.status);

    return Scaffold(
      backgroundColor: const Color(0xff050B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xff050B1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Order Details",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff050B1E),
            // Color(0xff1C4D8D),
            // Color(0xff0F2854),
            Color(0xff393053),

          ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

          ),

        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// ORDER SUMMARY CARD
            _sectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Order #${order.id.substring(order.id.length - 6)}",
                      style: _titleStyle()),
                  const SizedBox(height: 6),
                  Text("Placed on ${formatDate(order.createdAt)}",
                      style: _subStyle()),
                  const SizedBox(height: 10),
                  _statusBadge(order.status),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// STATUS TRACKER
            _sectionCard(
              child: Column(
                children: List.generate(
                  3,
                      (i) => OrderStatusTile(
                    step: i == 0
                        ? "Ordered"
                        : i == 1
                        ? "Shipped"
                        : "Delivered",
                    completed: i <= completedIndex,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// PRODUCTS
            Text("Items", style: _titleStyle()),
            const SizedBox(height: 10),
            ...order.items.map((item) => _productTile(item)).toList(),

            const SizedBox(height: 16),

            /// PAYMENT INFO
            if (order.payment != null)
              _sectionCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Payment Method", style: _subStyle()),
                    Text(order.payment!.method,
                        style: _valueStyle(Colors.white)),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            /// TOTAL
            _sectionCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Amount", style: _titleStyle()),
                  Text("₹${order.totalAmount.toStringAsFixed(0)}",
                      style: _valueStyle(Colors.amber)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                // Show a loading indicator while generating PDF


                try {
                  await InvoicePdfService.generateInvoice(order: order);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to generate invoice: $e")),
                  );
                } finally {
                  Navigator.pop(context); // hide loading
                }
              },
              icon: const Icon(Icons.picture_as_pdf_rounded),
              label: const Text("Download Invoice"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  /// PRODUCT TILE WITH BIG IMAGE
  Widget _productTile(OrderItemModel item) {
    final product = item.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C23),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          if (product != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.images.first,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product?.name ?? "Product",
                    style: _valueStyle(Colors.white)),
                const SizedBox(height: 4),
                Text("Qty: ${item.quantity}", style: _subStyle()),
                const SizedBox(height: 4),
                Text("₹${item.price.toStringAsFixed(0)}",
                    style: _valueStyle(Colors.amber)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: child,
    );
  }

  Widget _statusBadge(String status) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
            color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  TextStyle _titleStyle() => GoogleFonts.poppins(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  TextStyle _subStyle() => GoogleFonts.poppins(
    color: Colors.white54,
    fontSize: 12,
  );

  TextStyle _valueStyle(Color color) => GoogleFonts.poppins(
    color: color,
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );
}
