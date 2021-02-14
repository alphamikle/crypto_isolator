import 'package:crypto_api_app/models/token_data.dart';
import 'package:crypto_api_app/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<DataCell> buildCells(TokenData tokenData) {
  final bool _isPositiveDiff = tokenData.diff >= 0;
  final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'ru_RU', symbol: r'$');
  final NumberFormat percentFormatter = NumberFormat.currency(locale: 'ru_RU', symbol: r'%');

  return [
    DataCell(Text(tokenData.title)),
    DataCell(Text(currencyFormatter.format(tokenData.price))),
    DataCell(Text(percentFormatter.format(tokenData.diff), style: TextStyle(color: _isPositiveDiff ? upColor : downColor))),
    DataCell(Text(currencyFormatter.format(tokenData.minPrice))),
    DataCell(Text(currencyFormatter.format(tokenData.maxPrice))),
  ];
}
