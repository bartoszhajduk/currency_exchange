import 'dart:convert';
import 'package:currency_exchange/model/currency.dart';
import 'package:currency_exchange/model/historical.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api {
  static const apiUrl = 'free.currconv.com';
  static const pathCurrencies = '/api/v7/currencies';
  static const pathConvert = '/api/v7/convert';
  static const apiKey = '0e2f68cc1f063d6c3144';
  static const compact = 'ultra';

  static Future<List<Currency>> getCurrencies() async {
    final url = Uri.https(apiUrl, pathCurrencies, {'apiKey': apiKey});
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

  static Future<double> getConversionResult(String q, String amount ) async {
    final url = Uri.https(apiUrl, pathConvert, {'apiKey': apiKey, 'q': q, 'compact': compact});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)[q];
      return double.parse(amount)* result;
    } else {
      throw Exception('Failed to convert');
    }
  }

  /// Get historical data from now to 8 days ago
  static Future<List<Historical>> getHistorical({
    @required String fromCurrency,
    @required String toCurrency,
    @required DateTime dateEnd,
  }) async {
    final convert = '${fromCurrency}_$toCurrency';
    final dateStart = dateEnd.subtract(Duration(days: 8));

    final url = Uri.https(apiUrl, pathConvert, {
      'q': convert,
      'compact': 'ultra',
      'date': '${dateStart.year}-${dateStart.month}-${dateStart.day}',
      'endDate': '${dateEnd.year}-${dateEnd.month}-${dateEnd.day}',
      'apiKey': apiKey,
    });
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final keyList = responseBody[convert] as Map;
      final historicalList = keyList.keys
          .map((key) => Historical(
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                date: key,
                value: keyList[key],
              ))
          .toList();
      return historicalList != null ? historicalList : List.empty();
    } else {
      throw Exception('Failed to load historical data');
    }
  }
}
