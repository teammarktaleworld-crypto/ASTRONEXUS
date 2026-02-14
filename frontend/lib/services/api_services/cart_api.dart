import 'package:flutter/cupertino.dart';

import '../../App/Model/cart_model.dart';
import 'api_client.dart';
import 'api_endpoints.dart';

class CartApi {
  final ApiClient _client = ApiClient();

  /// =====================
  /// GET CART
  /// =====================
  Future<CartModel> getCart() async {
    final data = await _client.get(ApiEndpoints.cart);

    if (data['success'] != true) {
      throw Exception(data['message'] ?? "Failed to load cart");
    }

    final cartJson = data['cart'] ?? {"items": []};
    return CartModel.fromJson(cartJson);
  }


  /// =====================
  /// ADD TO CART
  /// =====================
  Future<void> addToCart(String productId, int quantity) async {
    final response = await _client.post(
      ApiEndpoints.addToCart,
      {
        "productId": productId,
        "quantity": quantity,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? "Add to cart failed");
    }
  }

  /// =====================
  /// UPDATE ITEM
  /// =====================
  Future<void> updateCartItem(String productId, int quantity) async {
    final response = await _client.post(
      ApiEndpoints.updateCart,
      {
        "productId": productId,
        "quantity": quantity,
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? "Update cart failed");
    }
  }


  /// =====================
  /// REMOVE ITEM
  /// =====================
  Future<void> removeCartItem(String productId) async {
    final response = await _client.delete(
      "${ApiEndpoints.removeCart}/$productId",
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? "Remove cart failed");
    }
  }
}
