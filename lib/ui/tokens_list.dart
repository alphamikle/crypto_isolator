import 'package:crypto_isolator/models/token_data.dart';
import 'package:crypto_isolator/ui/token_row/token_row.dart';
import 'package:flutter/material.dart';

class TokensList extends StatelessWidget {
  const TokensList({
    @required this.tokens,
    @required this.isLoading,
    Key key,
  }) : super(key: key);

  final List<TokenData> tokens;
  final bool isLoading;

  Widget _tokenRowBuilder(BuildContext context, int index) => TokenRow(tokenData: tokens[index], index: index);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scrollbar(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: _tokenRowBuilder,
              itemCount: tokens.length,
            ),
          );
  }
}
