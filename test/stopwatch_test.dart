import 'package:flutter_test/flutter_test.dart';
import 'package:tugas2mobile/services/stopwatch_service.dart';

void main() {
  group('StopwatchService Tests', () {
    late StopwatchService service;

    setUp(() {
      service = StopwatchService();
      service.reset();
    });

    test('Initial state is stopped with 0 elapsed and empty laps', () {
      expect(service.isRunning, isFalse);
      expect(service.elapsedMilliseconds, 0);
      expect(service.laps, isEmpty);
    });

    test('Start and pause changes running state', () async {
      service.start();
      expect(service.isRunning, isTrue);

      await Future.delayed(const Duration(milliseconds: 100));
      expect(service.elapsedMilliseconds, greaterThan(0));

      service.pause();
      expect(service.isRunning, isFalse);
      final int pausedTime = service.elapsedMilliseconds;

      await Future.delayed(const Duration(milliseconds: 50));
      expect(service.elapsedMilliseconds, equals(pausedTime));
    });

    test('Lap recording tracks lap number and split times', () async {
      service.start();
      await Future.delayed(const Duration(milliseconds: 80));
      service.recordLap();

      expect(service.laps.length, 1);
      expect(service.laps.first.lapNumber, 1);
      expect(service.laps.first.lapTimeMs, greaterThan(0));

      await Future.delayed(const Duration(milliseconds: 80));
      service.recordLap();

      expect(service.laps.length, 2);
      expect(service.laps.first.lapNumber, 2);
      expect(service.laps[1].lapNumber, 1);

      service.reset();
      expect(service.laps, isEmpty);
      expect(service.elapsedMilliseconds, 0);
      expect(service.isRunning, isFalse);
    });

    test('formatTime formats milliseconds accurately', () {
      expect(StopwatchService.formatTime(0), '00:00:00.00');
      expect(StopwatchService.formatTime(1500), '00:00:01.50');
      expect(StopwatchService.formatTime(65430), '00:01:05.43');
      expect(StopwatchService.formatTime(3661000, includeCentis: false), '01:01:01');
    });
  });
}
