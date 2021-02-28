import 'dart:async';
import 'dart:isolate';

import 'package:crypto_isolator/base/token_state.dart';
import 'package:crypto_isolator/binance/binance_service.dart';
import 'package:crypto_isolator/models/token_data.dart';
import 'package:flutter/cupertino.dart';

class IsolateState extends TokenState {
  IsolateState(BinanceService binanceService) : super(binanceService);

  final List<TokenData> _tokens = [];

  bool _isLoading = true;

  StreamSubscription<dynamic> _receivePortSubscription;

  Isolate _isolate;

  ReceivePort _receivePort;

  @override
  bool get isLoading => _isLoading;

  @override
  List<TokenData> get tokens => List.from(_tokens, growable: false);

  @override
  Future<void> start() async {
    _receivePort = ReceivePort();
    final BinanceService binanceService = this.binanceService;
    _isolate = await _startIsolate(Wrapper(sendPort: _receivePort.sendPort, data: binanceService));
    _receivePortSubscription = _receivePort.listen(_handleReceiveStream);
  }

  Future<void> _handleReceiveStream(dynamic data) async {
    if (data is List<TokenData>) {
      _fillTokens(data);
    }
  }

  void _fillTokens(List<TokenData> tokens) {
    if (_isLoading) {
      _isLoading = false;
    }
    _tokens.clear();
    _tokens.addAll(tokens);
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    await _receivePortSubscription.cancel();
    _isLoading = true;
    _tokens.clear();
    _isolate.kill();
  }
}

class Wrapper<T> {
  const Wrapper({
    @required this.sendPort,
    @required this.data,
  }) : assert(sendPort != null && data != null);

  final SendPort sendPort;

  final T data;
}

class _IsolateBinanceWrapper {
  _IsolateBinanceWrapper({
    @required this.binanceService,
    @required this.sendPort,
  }) : assert(binanceService != null && sendPort != null) {
    initBinance();
  }

  final BinanceService binanceService;

  final SendPort sendPort;

  final List<TokenData> tokens = [];

  final Map<String, TokenData> tokensBySymbols = {};

  Future<void> initBinance() async {
    await binanceService.connect();
    binanceService.stream.listen(sendMessageToIsolateState);
  }

  void sendMessageToIsolateState(List<TokenData> tokens) {
    for (final TokenData tokenData in tokens) {
      tokensBySymbols[tokenData.title] = tokenData;
    }
    this.tokens.clear();
    this.tokens.addAll(tokensBySymbols.values);
    this.tokens.sort(predicateForSortingByTitle);
    sendPort.send(this.tokens);
  }
}

Future<Isolate> _startIsolate(Wrapper<BinanceService> wrapper) => Isolate.spawn<Wrapper<BinanceService>>(_handleSocketData, wrapper, errorsAreFatal: true);

void _handleSocketData(Wrapper<BinanceService> wrapper) => _IsolateBinanceWrapper(binanceService: wrapper.data, sendPort: wrapper.sendPort);
