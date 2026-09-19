import 'package:flutter/material.dart';
import '../services/stopwatch_service.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StopwatchService stopwatchService = StopwatchService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Stopwatch'),
      ),
      body: ListenableBuilder(
        listenable: stopwatchService,
        builder: (context, _) {
          final int elapsed = stopwatchService.elapsedMilliseconds;
          final bool isRunning = stopwatchService.isRunning;
          final List<LapItem> laps = stopwatchService.laps;

          // Compute fastest and slowest laps if >= 2 laps
          int? fastestLapNum;
          int? slowestLapNum;
          if (laps.length >= 2) {
            int minDuration = laps.first.lapTimeMs;
            int maxDuration = laps.first.lapTimeMs;
            fastestLapNum = laps.first.lapNumber;
            slowestLapNum = laps.first.lapNumber;

            for (final lap in laps) {
              if (lap.lapTimeMs < minDuration) {
                minDuration = lap.lapTimeMs;
                fastestLapNum = lap.lapNumber;
              }
              if (lap.lapTimeMs > maxDuration) {
                maxDuration = lap.lapTimeMs;
                slowestLapNum = lap.lapNumber;
              }
            }
          }

          // Split display into main time (HH:MM:SS) and centiseconds (.CS)
          final String formattedFull = StopwatchService.formatTime(elapsed, includeCentis: true);
          final List<String> parts = formattedFull.split('.');
          final String mainTime = parts[0];
          final String centis = parts.length > 1 ? parts[1] : '00';

          return Column(
            children: [
              // Top Timer Display Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isRunning
                            ? Colors.green.shade50
                            : (elapsed > 0 ? Colors.orange.shade50 : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isRunning
                              ? Colors.green.shade300
                              : (elapsed > 0 ? Colors.orange.shade300 : Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRunning
                                ? Icons.play_circle_fill
                                : (elapsed > 0 ? Icons.pause_circle_filled : Icons.stop_circle_outlined),
                            size: 14,
                            color: isRunning
                                ? Colors.green.shade700
                                : (elapsed > 0 ? Colors.orange.shade800 : Colors.grey.shade600),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isRunning
                                ? 'SEDANG BERJALAN'
                                : (elapsed > 0 ? 'DIJEDA' : 'SIAP'),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isRunning
                                  ? Colors.green.shade700
                                  : (elapsed > 0 ? Colors.orange.shade800 : Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Big Digits with tabular figures for stable numbers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          mainTime,
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          '.$centis',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade400,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Controls Row: [LAP] [START/PAUSE] [RESET]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // LAP BUTTON
                        ElevatedButton.icon(
                          onPressed: isRunning ? stopwatchService.recordLap : null,
                          icon: const Icon(Icons.flag, size: 18),
                          label: const Text('LAP'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade200,
                            disabledForegroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // START / PAUSE BUTTON
                        ElevatedButton.icon(
                          onPressed: isRunning ? stopwatchService.pause : stopwatchService.start,
                          icon: Icon(
                            isRunning ? Icons.pause : Icons.play_arrow,
                            size: 20,
                          ),
                          label: Text(isRunning ? 'PAUSE' : (elapsed > 0 ? 'LANJUT' : 'START')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning ? Colors.orange : Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // RESET BUTTON
                        ElevatedButton.icon(
                          onPressed: (elapsed > 0 || laps.isNotEmpty)
                              ? stopwatchService.reset
                              : null,
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('RESET'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade200,
                            disabledForegroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Section Header: Daftar Putaran
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daftar Putaran (Lap)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (laps.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          '${laps.length} Putaran',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Lap List
              Expanded(
                child: laps.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada putaran',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tekan tombol LAP saat stopwatch berjalan\nuntuk mencatat putaran waktu.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              ),
                              child: const Row(
                                children: [
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      'Putaran',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Waktu Lap',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      'Total Waktu',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),

                            // Rows
                            Expanded(
                              child: ListView.separated(
                                itemCount: laps.length,
                                separatorBuilder: (_, _) => const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final lap = laps[index];
                                  final bool isFastest = lap.lapNumber == fastestLapNum;
                                  final bool isSlowest = lap.lapNumber == slowestLapNum;

                                  Color? rowBg;
                                  Color textColor = Colors.black87;
                                  Widget? badge;

                                  if (isFastest) {
                                    rowBg = Colors.green.shade50.withValues(alpha: 0.6);
                                    textColor = Colors.green.shade800;
                                    badge = Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Tercepat',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade800,
                                        ),
                                      ),
                                    );
                                  } else if (isSlowest) {
                                    rowBg = Colors.red.shade50.withValues(alpha: 0.6);
                                    textColor = Colors.red.shade800;
                                    badge = Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Terlama',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red.shade800,
                                        ),
                                      ),
                                    );
                                  }

                                  return Container(
                                    color: rowBg,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 70,
                                          child: Text(
                                            'Lap ${lap.lapNumber.toString().padLeft(2, '0')}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                StopwatchService.formatTime(lap.lapTimeMs),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: textColor,
                                                  fontFeatures: const [FontFeature.tabularFigures()],
                                                ),
                                              ),
                                              ?badge,
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: Text(
                                            StopwatchService.formatTime(lap.totalTimeMs),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontFeatures: const [FontFeature.tabularFigures()],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
