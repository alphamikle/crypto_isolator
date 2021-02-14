const int LOG_PADDING = 70;

class _Benchmark {
  final Map<String, int> _starts = <String, int>{};

  void start(dynamic id) {
    final String benchId = id.toString();
    if (_starts.containsKey(benchId)) {
      print('Benchmark already have comparing with id=$benchId in time');
    } else {
      _starts[benchId] = DateTime.now().microsecondsSinceEpoch;
    }
  }

  void end(dynamic id) {
    final String benchId = id.toString();
    if (!_starts.containsKey(benchId)) {
      print('In Benchmark not placed comparing with id=$benchId');
    } else {
      print('$benchId need ${(DateTime.now().microsecondsSinceEpoch - _starts[benchId]) / 1000}ms');
      _starts.remove(benchId);
    }
  }

  void startService(dynamic id) {
    start('$id'.padLeft(LOG_PADDING, ':'));
  }

  void endService(dynamic id) {
    end('$id'.padLeft(LOG_PADDING, ':'));
  }
}

final _Benchmark bench = _Benchmark();
