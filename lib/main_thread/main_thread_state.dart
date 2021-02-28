import 'dart:async';

import 'package:crypto_isolator/base/token_state.dart';
import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/models/token_data.dart';

class MainThreadState extends TokenState {
  MainThreadState(BinanceService binanceService) : super(binanceService);

  final List<TokenData> _tokens = [];

  final Map<String, TokenData> _tokensBySymbols = {};

  bool _isLoading = true;

  StreamSubscription<List<TokenData>> _subscription;

  @override
  bool get isLoading => _isLoading;

  @override
  List<TokenData> get tokens => List.from(_tokens, growable: false);

  @override
  Future<void> start() async {
    await binanceService.connect();
    _subscription = binanceService.stream.listen(_fillTokens);
  }

  void _fillTokens(List<TokenData> tokens) {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
    for (final TokenData tokenData in tokens) {
      _tokensBySymbols[tokenData.title] = tokenData;
    }
    _tokens.clear();
    _tokens.addAll(_tokensBySymbols.values);
    _tokens.sort(predicateForSortingByTitle);
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    await _subscription.cancel();
    binanceService.dispose();
    _isLoading = true;
    _tokens.clear();
    _tokensBySymbols.clear();
  }
}
