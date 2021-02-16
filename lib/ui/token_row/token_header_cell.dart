import 'package:crypto_isolator/style.dart';
import 'package:flutter/material.dart';

class TokenHeaderCell extends StatelessWidget {
  const TokenHeaderCell(
    this.title, {
    Key key,
    this.textAlign = TextAlign.end,
  }) : super(key: key);

  final String title;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, color: background),
      textAlign: textAlign,
    );
  }
}
