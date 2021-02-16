import 'package:crypto_isolator/config.dart';
import 'package:crypto_isolator/models/token_data.dart';
import 'package:crypto_isolator/style.dart';
import 'package:crypto_isolator/ui/token_row/token_percent.dart';
import 'package:crypto_isolator/ui/token_row/token_price.dart';
import 'package:crypto_isolator/ui/token_row/token_title.dart';
import 'package:flutter/material.dart';

class TokenRow extends StatelessWidget {
  const TokenRow({
    @required this.tokenData,
    @required this.index,
    Key key,
  }) : super(key: key);

  final TokenData tokenData;
  final int index;
  bool get _isEven => index.isEven;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isEven ? Colors.white.withOpacity(0.05) : Colors.blue.withOpacity(0.05),
      child: Padding(
        padding: p1,
        child: Row(
          children: [
            if (fieldsOfToken[0]) Expanded(child: TokenTitle(tokenData.title)),
            if (fieldsOfToken[1]) Expanded(child: TokenPrice(tokenData.price)),
            if (fieldsOfToken[2]) Expanded(child: TokenPercent(tokenData.diff)),
            if (fieldsOfToken[3]) Expanded(child: TokenPrice(tokenData.minPrice)),
            if (fieldsOfToken[4]) Expanded(child: TokenPrice(tokenData.maxPrice)),
          ],
        ),
      ),
    );
  }
}
