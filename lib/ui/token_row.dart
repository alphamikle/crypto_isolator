import 'package:crypto_api_app/models/token_data.dart';
import 'package:crypto_api_app/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TokenRow extends StatelessWidget {
  const TokenRow({
    @required this.tokenData,
    Key key,
  }) : super(key: key);

  final TokenData tokenData;

  bool get _isPositiveDiff => tokenData.diff >= 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text(tokenData.title)),
          Expanded(child: Text(NumberFormat.currency(locale: 'ru_RU', symbol: r'$').format(tokenData.price))),
          Expanded(child: Text('${tokenData.diff}%', style: TextStyle(color: _isPositiveDiff ? upColor : downColor))),
        ],
      ),
    );
  }
}
