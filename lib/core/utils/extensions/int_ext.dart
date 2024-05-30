import 'package:intl/intl.dart';

extension IntegerExt on int {
  String toCurrencyRp() {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }
}
