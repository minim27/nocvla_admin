import 'package:intl/intl.dart';

String parsingCurrency(dynamic value) {
  final r = NumberFormat.currency(
    locale: "id",
    symbol: "Rp ",
    decimalDigits: 0,
  ).format(value);
  return r;
}
