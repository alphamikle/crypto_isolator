import 'package:flutter/material.dart';

class TokenTitle extends StatelessWidget {
  const TokenTitle(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
  }
}
