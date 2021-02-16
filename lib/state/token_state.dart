import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/models/token_data.dart';
import 'package:flutter/cupertino.dart';

abstract class TokenState with ChangeNotifier {
  TokenState(this.binanceService);

  @protected
  final BinanceService binanceService;
  bool get isLoading;
  List<TokenData> get tokens;
  Future<void> start();

  @protected
  int predicateForSortingByTitle(TokenData first, TokenData second) {
    return first.title.compareTo(second.title);
  }
}
