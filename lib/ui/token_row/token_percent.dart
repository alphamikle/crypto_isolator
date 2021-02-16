import 'package:anitex/anitex.dart';
import 'package:crypto_isolator/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final NumberFormat percentFormatter = NumberFormat.currency(locale: 'ru_RU', symbol: r'%');

class TokenPercent extends StatelessWidget {
  const TokenPercent(this.percent, {Key key}) : super(key: key);

  final double percent;
  bool get _isPositiveDiff => percent >= 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedText(
      percentFormatter.format(percent),
      style: TextStyle(color: _isPositiveDiff ? upColor : downColor),
      useOpacity: false,
    );
  }
}
