import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../App/Model/wishlist_model.dart';
import '../API/APIservice.dart';

class WishlistService {
  final String token;

  WishlistService({required this.token});

  /// Get wishlist
  Future<WishlistModel> getWishlist() async {
    final res = await http.get(
      Uri.parse('$baseurl/user/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("GET Wishlist Response Code: ${res.statusCode}");
    print("GET Wishlist Response Body: ${res.body}");

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      print("Decoded Wishlist JSON: $decoded");
      return WishlistModel.fromJson(decoded);
    }

    throw Exception("Failed to load wishlist: ${res.statusCode}");
  }

  /// Add ONE product
  Future<void> addProduct(String productId) async {
    final res = await http.post(
      Uri.parse('$baseurl/user/wishlist'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': 'Default', 'productId': productId}),
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception("Add wishlist failed");
    }
  }

  /// Remove ONE product
  Future<void> removeProduct(String productId) async {
    final res = await http.delete(
      Uri.parse('$baseurl/user/wishlist/remove'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': 'Default', 'productId': productId}),
    );

    if (res.statusCode != 200) {
      throw Exception("Remove wishlist failed");
    }
  }
}