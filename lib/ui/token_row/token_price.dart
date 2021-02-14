import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'ru_RU', symbol: r'$');

class TokenPrice extends StatelessWidget {
  const TokenPrice(this.price, {Key key}) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Text(currencyFormatter.format(price));
  }
}
