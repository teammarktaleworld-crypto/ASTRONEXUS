import 'dart:convert';
import 'package:astro_tale/services/API/APIservice.dart';
import 'package:http/http.dart' as http;

import '../../App/Model/wallet_model.dart';

class WalletApi {

  static Future<Wallet> getWallet(String userId) async {
    final url = '$baseurl/user/$userId';
    print('GET WALLET => $url');

    final response = await http.get(Uri.parse(url));
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      return Wallet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load wallet');
    }
  }

  static Future<double> deposit(String userId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseurl/user/$userId/deposit'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body)['balance'] as num).toDouble();
    } else {
      throw Exception('Deposit failed');
    }
  }

  static Future<double> withdraw(String userId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseurl/user/$userId/withdraw'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body)['balance'] as num).toDouble();
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }
}