import 'package:crypto_api_app/models/token_data.dart';
import 'package:crypto_api_app/style.dart';
import 'package:crypto_api_app/ui/token_row/token_percent.dart';
import 'package:crypto_api_app/ui/token_row/token_price.dart';
import 'package:crypto_api_app/ui/token_row/token_title.dart';
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
      color: _isEven ? Colors.white.withOpacity(0.075) : Colors.blue.withOpacity(0.075),
      child: Padding(
        padding: p1,
        child: Row(
          children: [
            Expanded(child: TokenTitle(tokenData.title)),
            Expanded(child: TokenPrice(tokenData.price)),
            Expanded(child: TokenPercent(tokenData.diff)),
            Expanded(child: TokenPrice(tokenData.minPrice)),
            Expanded(child: TokenPrice(tokenData.maxPrice)),
          ],
        ),
      ),
    );
  }
}
