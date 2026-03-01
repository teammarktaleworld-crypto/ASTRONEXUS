// services/product_suggestion.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astro_tale/services/API/APIservice.dart';

import '../../../App/Model/suggestion_model.dart';

class ProductSuggestionService {
  final String apiUrl = '$baseurl/user/home-products';

  Future<List<ProductSuggestion>> fetchSuggestions() async {
    print("Calling API: $apiUrl"); // <-- add this
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final products = (data['products'] as List)
            .map((json) => ProductSuggestion.fromJson(json))
            .toList();
        return products;
      } else {
        throw Exception('Failed to fetch product suggestions');
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
      return [];
    }
  }
}