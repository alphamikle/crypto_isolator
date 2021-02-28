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
  SendPort _sendPort;

  @override
  bool get isLoading => _isLoading;
  @override
  List<TokenData> get tokens => List.from(_tokens, growable: false);

  @override
  Future<void> start() async {
    print('Isolate state was started');
    _receivePort = ReceivePort();
    final BinanceService binanceService = this.binanceService;
    _isolate = await _startIsolate(Wrapper(sendPort: _receivePort.sendPort, data: binanceService));
    _receivePortSubscription = _receivePort.listen(_handleReceiveStream);
  }

  Future<void> _handleReceiveStream(dynamic data) async {
    if (data is SendPort) {
      _sendPort = data;
    } else if (data is List<TokenData>) {
      _fillTokens(data);
    } else {
      throw Exception('UNKNOWN DATA TYPE: $data');
    }
  }

  void _fillTokens(List<TokenData> tokens) {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
    _tokens.clear();
    _tokens.addAll(tokens);
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    print('Isolate state was disposed');
    await _receivePortSubscription.cancel();
    _sendPort = null;
    binanceService.dispose();
    _isLoading = true;
    _tokens.clear();
    _isolate.kill();
    notifyListeners();
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
  })  : assert(binanceService != null && sendPort != null),
        receivePort = ReceivePort() {
    sendPort.send(receivePort.sendPort);
    receivePort.listen(_handleMessages);
    initBinance();
  }

  final BinanceService binanceService;
  final ReceivePort receivePort;
  final SendPort sendPort;
  final List<TokenData> tokens = [];
  final Map<String, TokenData> tokensBySymbols = {};

  Future<void> _handleMessages(dynamic message) async {
    print('GOT MESSAGE FROM ISOLATE STATE: $message');
  }

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
