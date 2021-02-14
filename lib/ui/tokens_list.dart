import 'package:crypto_api_app/models/token_data.dart';
import 'package:crypto_api_app/ui/token_row.dart';
import 'package:flutter/material.dart';

class TokensList extends StatelessWidget {
  const TokensList({
    @required this.tokens,
    Key key,
  }) : super(key: key);

  final List<TokenData> tokens;

  Widget _tokenRowBuilder(BuildContext context, int index) => TokenRow(tokenData: tokens[index], index: index);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: _tokenRowBuilder,
        itemCount: tokens.length,
      ),
    );
  }
}
