import 'dart:async';
import 'dart:convert';

import 'package:crypto_isolator/models/token_data.dart';
import 'package:web_socket_channel/io.dart';

class BinanceService {
  BinanceService({
    this.useRawData = false,
  });

  final bool useRawData;
  final String _url = 'wss://stream.binance.com:9443/ws/!ticker@arr';
  IOWebSocketChannel _channel;

  Stream<List<TokenData>> get stream {
    if (useRawData) {
      throw Exception('In raw $BinanceService available only rawStream');
    }
    return _channel?.stream?.map<List<TokenData>>(transformCryptoStringToTokensData)?.asBroadcastStream();
  }

  Stream<String> get rawStream {
    if (!useRawData) {
      throw Exception('In simple $BinanceService available only stream');
    }
    return _channel?.stream?.cast<String>()?.asBroadcastStream();
  }

  Future<void> connect() async {
    await _channel?.sink?.close();
    _channel = IOWebSocketChannel.connect(_url);
  }

  void dispose() {
    _channel?.sink?.close();
  }
}

List<TokenData> transformCryptoStringToTokensData(dynamic rawData) {
  final List<dynamic> json = jsonDecode(rawData as String);
  final List<TokenData> tokens = json.where(_predicateForUSDT).map(_transformElement).toList();
  return tokens;
}

bool _predicateForUSDT(dynamic element) {
  return (element['s'] as String).contains('USDT');
}

TokenData _transformElement(dynamic element) {
  final String title = (element['s'] as String).replaceFirst('USDT', '');
  final double price = double.parse(element['c']);
  final double minPrice = double.parse(element['l']);
  final double maxPrice = double.parse(element['h']);
  final double diff = double.parse(element['P']);
  return TokenData(title: title, price: price, minPrice: minPrice, maxPrice: maxPrice, diff: diff);
}
