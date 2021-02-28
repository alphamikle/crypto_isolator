import 'package:crypto_isolator/config.dart';
import 'package:crypto_isolator/utils/fps_monitor.dart';
import 'package:flutter/services.dart';

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

void startFps([double refreshRate = deviceRefreshRate]) {
  FpsMonitor.instance.refreshRate = refreshRate;
  FpsMonitor.instance.start();
}

final List<double> frames = [];

Future<List<double>> stopFps({bool copy = true}) async {
  frames.clear();
  frames.addAll(FpsMonitor.instance.stop());
  final List<double> response = [...frames];
  if (copy) {
    final String framesData = frames.join('\n').replaceAll('.', ',');
    await Clipboard.setData(ClipboardData(text: framesData));
  }
  frames.clear();
  return response;
}

Future<String> computeTableOfFrames(List<List<double>> columnsOfFrames) async {
  final Map<int, String> rowsOfFrames = {};
  int columnsCount = 0;
  for (final List<double> columnOfFrames in columnsOfFrames) {
    int rowsCount = 0;
    for (final double frame in columnOfFrames) {
      if (rowsOfFrames[rowsCount] != null) {
        rowsOfFrames[rowsCount] = '${rowsOfFrames[rowsCount]}	$frame';
      } else {
        String tabs = '';
        for (int tabCount = 0; tabCount < columnsCount; tabCount++) {
          tabs = '$tabs	';
        }
        rowsOfFrames[rowsCount] = '$tabs$frame';
      }
      rowsCount++;
    }
    columnsCount++;
  }
  final String tableOfFrames = rowsOfFrames.values.join('\n').replaceAll('.', ',');
  await Clipboard.setData(ClipboardData(text: tableOfFrames));
  return tableOfFrames;
}
