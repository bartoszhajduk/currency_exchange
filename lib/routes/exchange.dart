import 'package:currency_exchange/model/currency.dart';
import 'package:currency_exchange/model/api.dart';
import 'package:currency_exchange/utils/app_colors.dart';
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
  final result = TextEditingController();
  //String result = '';
  bool isSwapping = false;
  List<Currency> currencyList = [];
  double currentRate;

  @override
  void initState() {
    super.initState();
    loadCurrencyList();
    amount.addListener(() {
      if (isAmountEntered() && areCurrenciesSelected() && !isSwapping) {
        getConversionResult();
      }
    });
    fromCurrency.addListener(() {
      if (areCurrenciesSelected() && !isSwapping) {
        getConversionRate();
      }
    });
    toCurrency.addListener(() {
      if (areCurrenciesSelected() && !isSwapping) {
        getConversionRate();
      }
    });
  }

  void loadCurrencyList() async {
    await Api.getCurrencies().then(
      (value) => setState(() {
        currencyList = value;
      }),
    );
  }

  bool isAmountEntered() => amount.text.isNotEmpty && amount.text != '.';

  bool areCurrenciesSelected() =>
      fromCurrency.text.isNotEmpty && toCurrency.text.isNotEmpty;

  void getConversionResult() async {
    setState(() {
      result.text =
          (double.parse(amount.text) * currentRate).toStringAsFixed(2);
    });
  }

  void getConversionRate() async {
    print(amount.text);

    if (!(currencyList.any((element) => element.id == fromCurrency.text) &&
        currencyList.any((element) => element.id == toCurrency.text))) {
      result.text = "Incorrect currency";
    } else {
      String from = currencyList
          .firstWhere((element) => element.id == fromCurrency.text)
          .id;
      String to = currencyList
          .firstWhere((element) => element.id == toCurrency.text)
          .id;
      await Api.getConversionResult('${from}_$to').then(
        (value) => setState(() {
          setState(() {
            currentRate = value;
          });
        }),
      );
    }
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
      backgroundColor: AppColors.background,
      body: Container(
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: ScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TypeAheadField<Currency>(
                          textFieldConfiguration: TextFieldConfiguration(
                            onTap: () => fromCurrency.clear(),
                            controller: fromCurrency,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.textIcons,
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: searchCurrencyByContains,
                          itemBuilder: (context, Currency currency) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            fromCurrency.text = '${currency.id}';
                          },
                          noItemsFoundBuilder: (context) => Text(
                            'Nothing found',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Ink(
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
                      ),
                      Expanded(
                        child: TypeAheadField<Currency>(
                          textFieldConfiguration: TextFieldConfiguration(
                            onTap: () => toCurrency.clear(),
                            controller: toCurrency,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.textIcons,
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          suggestionsCallback: searchCurrencyByContains,
                          itemBuilder: (context, Currency currency) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                            toCurrency.text = '${currency.id}';
                          },
                          noItemsFoundBuilder: (context) => Text(
                            'Nothing found',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: TextField(
                    controller: amount,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(([1-9]\d*)|[0])?(\.\d{0,2})?')),
                    ],
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.textIcons,
                      labelText: 'Amount',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.startsWith('.')) {
                        amount.text = '0' + amount.text;
                        amount.selection =
                            TextSelection.collapsed(offset: amount.text.length);
                      }
                    },
                  ),
                ),
                !isAmountEntered() || !areCurrenciesSelected()
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Card(
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${format(amount.text)} ${fromCurrency.text} ='),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: SelectableText(
                                      '${result.text} ${toCurrency.text}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Rate 1 ${fromCurrency.text} = ${currentRate.toStringAsFixed(2)} ${toCurrency.text}',
                                    style:
                                        TextStyle(color: AppColors.darkPrimary),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
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
    isSwapping = true;
    String tmp = fromCurrency.text;

    setState(() {
      fromCurrency.text = toCurrency.text;
      toCurrency.text = tmp;
    });

    isSwapping = false;

    if (isAmountEntered() && areCurrenciesSelected()) {
      getConversionResult();
    }
  }

  String format(String number) {
    return double.parse(number).toStringAsFixed(2);
  }
}
