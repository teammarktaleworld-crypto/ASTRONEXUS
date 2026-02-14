import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../App/Model/tarot_model.dart';
import '../API/APIservice.dart';

class TarotApi {
  static Future<List<TarotCard>> fetchCards(int count) async {
    final url = Uri.parse('$baseurl/api/tarot/random?n=$count');

    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['cards'] as List)
          .map((e) => TarotCard.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load tarot cards');
    }
  }
}
