import 'package:crypto_api_app/models/token_data.dart';
import 'package:crypto_api_app/style.dart';
import 'package:crypto_api_app/ui/token_row/token_percent.dart';
import 'package:crypto_api_app/ui/token_row/token_price.dart';
import 'package:crypto_api_app/ui/token_row/token_title.dart';
import 'package:flutter/material.dart';

const List<DataColumn> _columns = [
  DataColumn(label: Text('Token'), numeric: false, tooltip: 'Token title'),
  DataColumn(label: Text('Price'), numeric: false, tooltip: 'Token price in USD'),
  DataColumn(label: Text('24h Change'), numeric: false, tooltip: 'Change of price in last 24 hours'),
  DataColumn(label: Text('24h Max'), numeric: false, tooltip: 'Max price in last 24 hours'),
  DataColumn(label: Text('24h Min'), numeric: false, tooltip: 'Min price in last 24 hours'),
];

class TokensTable extends StatelessWidget {
  const TokensTable({
    @required this.tokens,
    Key key,
  }) : super(key: key);

  final List<TokenData> tokens;

  List<DataCell> buildCells(TokenData tokenData) {
    return [
      DataCell(TokenTitle(tokenData.title)),
      DataCell(TokenPrice(tokenData.price)),
      DataCell(TokenPercent(tokenData.diff)),
      DataCell(TokenPrice(tokenData.minPrice)),
      DataCell(TokenPrice(tokenData.maxPrice)),
    ];
  }

  List<DataRow> get _rows => tokens.map((TokenData tokenData) => DataRow(cells: buildCells(tokenData))).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            dividerThickness: 0.25,
            showBottomBorder: true,
            showCheckboxColumn: true,
            columnSpacing: 30,
            columns: _columns,
            rows: _rows,
          ),
        ),
      ),
    );
  }
}
