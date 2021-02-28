import 'dart:async';

import 'package:crypto_isolator/base/token_state.dart';
import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/models/token_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:isolator/isolator.dart';

enum IsolatorEvent { dataPiece }

class IsolatorState extends TokenState with Frontend<IsolatorEvent> {
  IsolatorState(BinanceService binanceService) : super(binanceService);

  final List<TokenData> _tokens = [];

  bool _isLoading = true;

  @override
  bool get isLoading => _isLoading;

  @override
  List<TokenData> get tokens => List.from(_tokens, growable: false);

  @override
  Future<void> start() => initBackend(_createIsolatorBackend, data: Packet(binanceService));

  void _setData(List<TokenData> tokens) {
    if (_isLoading) {
      _isLoading = false;
    }
    _tokens.clear();
    _tokens.addAll(tokens);
  }

  @override
  void onBackendResponse() => notifyListeners();

  @override
  Future<void> reset() async {
    print('Isolator state was disposed');
    _isLoading = true;
    _tokens.clear();
    killBackend();
  }

  @override
  Map<IsolatorEvent, Function> get tasks => {
        IsolatorEvent.dataPiece: _setData,
      };
}

class _IsolatorBackend extends Backend<IsolatorEvent, void> {
  _IsolatorBackend({
    @required BackendArgument<void> argument,
    @required this.binanceService,
  })  : assert(argument != null && binanceService != null),
        super(argument);

  final BinanceService binanceService;

  final List<TokenData> tokens = [];

  final Map<String, TokenData> tokensBySymbols = {};

  @override
  Future<void> init() async {
    await binanceService.connect();
    binanceService.stream.listen(binanceHandler);
    await super.init();
  }

  void binanceHandler(List<TokenData> tokens) {
    for (final TokenData tokenData in tokens) {
      tokensBySymbols[tokenData.title] = tokenData;
    }
    this.tokens.clear();
    this.tokens.addAll(tokensBySymbols.values);
    this.tokens.sort(predicateForSortingByTitle);
    send(IsolatorEvent.dataPiece, this.tokens);
  }

  @override
  Map<IsolatorEvent, Function> get operations => {};
}

void _createIsolatorBackend(BackendArgument<Packet<BinanceService>> argument) => _IsolatorBackend(argument: argument, binanceService: argument.data.value);
