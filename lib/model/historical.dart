class Historical {
  final String fromCurrency;
  final String toCurrency;
  final String date;
  final double value;

  Historical({
    this.fromCurrency,
    this.toCurrency,
    this.date,
    this.value,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Historical &&
          runtimeType == other.runtimeType &&
          fromCurrency == other.fromCurrency &&
          toCurrency == other.toCurrency &&
          date == other.date &&
          value == other.value;

  @override
  String toString() {
    return 'Historical {fromCurrency: $fromCurrency, toCurrency: $toCurrency, date: $date, value: $value}';
  }

  @override
  int get hashCode =>
      fromCurrency.hashCode ^
      toCurrency.hashCode ^
      date.hashCode ^
      value.hashCode;
}
