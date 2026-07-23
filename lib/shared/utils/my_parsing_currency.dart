import 'package:intl/intl.dart';

String parsingCurrency(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "Rp ",
    decimalDigits: 0,
  ).format(value);
  return r;
}

String parsingCurrencyAdd(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "+Rp ",
    decimalDigits: 0,
  ).format(value);
  return r;
}

String parsingCurrencyMin(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "-Rp ",
    decimalDigits: 0,
  ).format(value);
  return r;
}

String parsingCurrencyNonSymbol(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "",
    decimalDigits: 0,
  ).format(value);
  return r;
}

String parsingCurrencyAddNonSymbol(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "+",
    decimalDigits: 0,
  ).format(value);
  return r;
}

String parsingCurrencyMinNonSaymbol(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "-",
    decimalDigits: 0,
  ).format(value);
  return r;
}

String parsingThousandToK(dynamic value) {
  final r = NumberFormat.compact().format(value);
  return r;
}

String parsingThousandToRB(int number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1).replaceAll('.0', '')}M';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1).replaceAll('.0', '')}jt';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1).replaceAll('.0', '')}rb';
  } else {
    return number.toString();
  }
}
