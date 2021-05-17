import 'package:currency_exchange/model/api.dart';
import 'package:currency_exchange/model/currency.dart';
import 'package:currency_exchange/model/historical.dart';
import 'package:currency_exchange/utils/app_colors.dart';
import 'package:currency_exchange/widgets/curr_chart.dart';
import 'package:currency_exchange/widgets/curr_dropdown_button.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String fromCurrency = 'USD';
  String toCurrency = 'PLN';
  String textDate = '';
  String textValue = '';
  List<Historical> values = <Historical>[];
  List<Currency> currencies = <Currency>[];

  void loadCurrencyList() async {
    final data = await Api.getCurrencies();
    setState(() {
      currencies = data;
    });
  }

  void loadHistoricalData() async {
    if (fromCurrency == toCurrency) {
      setState(() {
        values = [];
      });
    } else {
      final data = await Api.getHistorical(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        dateEnd: DateTime.now(),
      );
      setState(() {
        values = data;
        textValue = values.first.value.toString();
        textDate = values.first.date.toString();
      });
    }
  }

  @override
  void initState() {
    loadCurrencyList();
    loadHistoricalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPadding = 10.0;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.textIcons,
          child: Padding(
            padding: EdgeInsets.all(screenPadding),
            child: Column(
              children: [
                /// * * * DROPDOWN BUTTONS * * *
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: CurrDropdownButton(
                        value: fromCurrency,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              fromCurrency = value;
                            });
                            loadHistoricalData();
                          }
                        },
                        itemList: currencies.map((e) => e.id).toList(),
                      ),
                    ),
                    SizedBox(width: screenPadding - 4),
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.arrow_forward),
                    ),
                    SizedBox(width: screenPadding),
                    Expanded(
                      flex: 10,
                      child: CurrDropdownButton(
                        value: toCurrency,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              toCurrency = value;
                            });
                            loadHistoricalData();
                          }
                        },
                        itemList: currencies.map((e) => e.id).toList(),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenPadding),

                /// * * * CHART * * *
                CurrChart(
                  height: 400,
                  separatorWidth: 0.3,
                  width: screenWidth - screenPadding * 2,
                  onPressed: (index, value) {
                    setState(() {
                      textDate = values[index].date;
                      textValue = values[index].value.toString();
                    });
                  },
                  values: values.map((e) => e.value).toList(),
                  barColor: AppColors.lightPrimary,
                  selectedBarColor: AppColors.darkPrimary,
                ),

                /// * * * VALUE DESCRIPTION * * *
                Padding(
                  padding: EdgeInsets.all(screenPadding),
                  child: Column(
                    children: [
                      Text(
                        textDate,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 17.0,
                        ),
                      ),
                      Text(
                        '1 $fromCurrency = $textValue $toCurrency',
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
