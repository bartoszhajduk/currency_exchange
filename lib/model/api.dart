import 'dart:convert';
import 'package:currency_exchange/model/currency.dart';
import 'package:http/http.dart' as http;

class Api {
  static const apiUrl = 'free.currconv.com';
  static const path = '/api/v7/currencies';
  static const apiKey = '0e2f68cc1f063d6c3144';

  static Future<List<Currency>> getCurrencies() async {
    final url = Uri.https(apiUrl, path, {'apiKey': apiKey});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final keyList = responseBody['results'] as Map;
      final currencyList =
          keyList.keys.map((key) => Currency.fromJson(keyList[key])).toList();
      return keyList != null ? currencyList : List.empty();
    } else {
      throw Exception('Failed to load currencies');
    }
  }
}
