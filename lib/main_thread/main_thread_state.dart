import 'dart:async';

import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/models/token_data.dart';
import 'package:crypto_isolator/state/token_state.dart';

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
    print('MAIN THREAD STATE START');
    await binanceService.connect();
    _subscription = binanceService.stream.listen(_fillTokens);
    _isLoading = false;
    notifyListeners();
  }

  void _fillTokens(List<TokenData> tokens) {
    for (final TokenData tokenData in tokens) {
      _tokensBySymbols[tokenData.title] = tokenData;
    }
    _tokens.clear();
    _tokens.addAll(_tokensBySymbols.values);
    _tokens.sort(predicateForSortingByTitle);
    notifyListeners();
    print('Fill tokens ${_tokens.length}');
  }

  @override
  void dispose() {
    _subscription.cancel();
    binanceService.dispose();
    super.dispose();
  }
}
