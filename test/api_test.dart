import 'package:currency_exchange/model/api.dart';
import 'package:currency_exchange/model/historical.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Get historical data', () async {
    final histList = await Api.getHistorical(
      fromCurrency: 'USD',
      toCurrency: 'PLN',
      dateEnd: DateTime(2021, 5, 17),
    );
    final first = histList.first;
    final mather = Historical(
      fromCurrency: 'USD',
      toCurrency: 'PLN',
      date: '2021-05-09',
      value: 3.740973,
    );
    expect(first, mather);
  });
}
