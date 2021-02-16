import 'package:crypto_isolator/config.dart';
import 'package:crypto_isolator/ui/token_row/token_header_cell.dart';
import 'package:flutter/material.dart';

class TokensHeader extends StatelessWidget implements PreferredSizeWidget {
  const TokensHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          if (fieldsOfToken[0]) const Expanded(child: TokenHeaderCell('Title', textAlign: TextAlign.start)),
          if (fieldsOfToken[1]) const Expanded(child: TokenHeaderCell('Price')),
          if (fieldsOfToken[2]) const Expanded(child: TokenHeaderCell('Diff 24h')),
          if (fieldsOfToken[3]) const Expanded(child: TokenHeaderCell('Min 24h')),
          if (fieldsOfToken[4]) const Expanded(child: TokenHeaderCell('Max 24h')),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
