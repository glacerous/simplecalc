import 'dart:async';
import 'package:flutter/foundation.dart';

class LapItem {
  final int lapNumber;
  final int lapTimeMs;
  final int totalTimeMs;

  const LapItem({
    required this.lapNumber,
    required this.lapTimeMs,
    required this.totalTimeMs,
  });
}

class StopwatchService with ChangeNotifier {
  static final StopwatchService _instance = StopwatchService._internal();
  factory StopwatchService() => _instance;
  StopwatchService._internal();

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<LapItem> _laps = [];
  int _lastLapTotalMs = 0;

  bool get isRunning => _stopwatch.isRunning;
  int get elapsedMilliseconds => _stopwatch.elapsedMilliseconds;
  List<LapItem> get laps => List.unmodifiable(_laps);

  void start() {
    if (_stopwatch.isRunning) return;
    _stopwatch.start();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 40), (_) {
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    if (!_stopwatch.isRunning) return;
    _stopwatch.stop();
    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  void reset() {
    _stopwatch.stop();
    _stopwatch.reset();
    _timer?.cancel();
    _timer = null;
    _laps.clear();
    _lastLapTotalMs = 0;
    notifyListeners();
  }

  void recordLap() {
    if (!_stopwatch.isRunning) return;
    final int currentMs = _stopwatch.elapsedMilliseconds;
    final int lapDuration = currentMs - _lastLapTotalMs;
    
    _laps.insert(
      0,
      LapItem(
        lapNumber: _laps.length + 1,
        lapTimeMs: lapDuration,
        totalTimeMs: currentMs,
      ),
    );
    _lastLapTotalMs = currentMs;
    notifyListeners();
  }

  static String formatTime(int ms, {bool includeCentis = true}) {
    final int centis = (ms % 1000) ~/ 10;
    final int seconds = (ms ~/ 1000) % 60;
    final int minutes = (ms ~/ 60000) % 60;
    final int hours = ms ~/ 3600000;

    final String hStr = hours.toString().padLeft(2, '0');
    final String mStr = minutes.toString().padLeft(2, '0');
    final String sStr = seconds.toString().padLeft(2, '0');
    final String cStr = centis.toString().padLeft(2, '0');

    if (includeCentis) {
      return '$hStr:$mStr:$sStr.$cStr';
    }
    return '$hStr:$mStr:$sStr';
  }
}
