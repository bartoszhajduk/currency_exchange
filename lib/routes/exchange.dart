import 'package:currency_exchange/model/currency.dart';
import 'package:currency_exchange/model/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Exchange extends StatefulWidget {
  @override
  _ExchangeState createState() => _ExchangeState();
}

class _ExchangeState extends State<Exchange> {
  final amount = TextEditingController();
  final fromCurrency = TextEditingController();
  final toCurrency = TextEditingController();
  List<Currency> currencyList = [];

  @override
  void initState() {
    super.initState();
    loadCurrencyList();
  }

  void loadCurrencyList() async {
    await Api.getCurrencies().then(
      (value) => setState(() {
        currencyList = value;
      }),
    );
  }

  @override
  void dispose() {
    amount.dispose();
    fromCurrency.dispose();
    toCurrency.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextField(
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TypeAheadField<Currency>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: fromCurrency,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    labelText: 'from',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: searchCurrencyByContains,
                itemBuilder: (context, Currency currency) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            '${currency.currencyName}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          '${currency.currencySymbol ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onSuggestionSelected: (currency) {
                  fromCurrency.text = '${currency.currencyName}';
                },
                noItemsFoundBuilder: (context) => Text('Nothing found'),
              ),
            ),
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.indigo,
              ),
              child: IconButton(
                onPressed: () => swapCurrencies(),
                color: Colors.white,
                icon: Icon(Icons.autorenew),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TypeAheadField<Currency>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: toCurrency,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    labelText: 'to',
                    border: OutlineInputBorder(),
                  ),
                ),
                suggestionsCallback: searchCurrencyByContains,
                itemBuilder: (context, Currency currency) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            '${currency.currencyName}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Text(
                          '${currency.currencySymbol ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onSuggestionSelected: (currency) {
                  toCurrency.text = '${currency.currencyName}';
                },
                noItemsFoundBuilder: (context) => Text('Nothing found'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Currency> searchCurrencyByContains(String query) {
    return currencyList
        .where((currency) =>
            currency.currencyName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void swapCurrencies() {
    String tmp = fromCurrency.text;

    setState(() {
      fromCurrency.text = toCurrency.text;
      toCurrency.text = tmp;
    });

    // TODO: Update conversion result
  }
}
