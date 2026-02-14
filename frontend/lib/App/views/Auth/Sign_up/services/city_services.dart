import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../Model/place/place_suggestion.dart';

class PlaceApiService {
  static Future<List<PlaceSuggestion>> searchPlaces(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      "https://photon.komoot.io/api/"
          "?q=${Uri.encodeComponent(query)}"
          "&limit=8"
          "&osm_tag=place",
    );

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final features = data['features'] as List;

      return features
          .map((e) => PlaceSuggestion.fromJson(e))
          .where((p) => p.country.isNotEmpty)
          .toList();
    }

    return [];
  }
}
