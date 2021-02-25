import 'package:crypto_isolator/models/token_data.dart';
import 'package:crypto_isolator/ui/token_row/token_row.dart';
import 'package:flutter/material.dart';

class TokensList extends StatelessWidget {
  const TokensList({
    @required this.tokens,
    @required this.isLoading,
    @required this.controller,
    Key key,
  }) : super(key: key);

  final List<TokenData> tokens;
  final bool isLoading;
  final ScrollController controller;

  Widget _tokenRowBuilder(BuildContext context, int index) => TokenRow(tokenData: tokens[index], index: index);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Scrollbar(
              controller: controller,
              child: ListView.builder(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                itemBuilder: _tokenRowBuilder,
                itemCount: tokens.length,
              ),
            ),
    );
  }
}
