import 'package:flutter/material.dart';
import '../services/stopwatch_service.dart';
import '../theme/app_theme.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = StopwatchService();

    return Scaffold(
      appBar: AppBar(title: const Text('Aplikasi Stopwatch')),
      body: ListenableBuilder(
        listenable: service,
        builder: (context, _) {
          final elapsed = service.elapsedMilliseconds;
          final isRunning = service.isRunning;
          final laps = service.laps;

          int? fastestNum, slowestNum;
          if (laps.length >= 2) {
            final sorted = [...laps]..sort((a, b) => a.lapTimeMs.compareTo(b.lapTimeMs));
            fastestNum = sorted.first.lapNumber;
            slowestNum = sorted.last.lapNumber;
          }

          final parts = StopwatchService.formatTime(elapsed, includeCentis: true).split('.');
          final mainTime = parts[0];
          final centis = parts.length > 1 ? parts[1] : '00';

          return Column(
            children: [
              // Top Timer Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.snow,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cloud),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          mainTime,
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.obsidian,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          '.$centis',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.fog,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: isRunning ? service.recordLap : null,
                          icon: const Icon(Icons.flag_outlined, size: 18),
                          label: const Text('LAP'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isRunning ? AppTheme.cobalt : AppTheme.obsidian,
                            side: BorderSide(color: isRunning ? AppTheme.cobalt.withValues(alpha: 0.4) : AppTheme.cloud),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: isRunning ? service.pause : service.start,
                          icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 20),
                          label: Text(isRunning ? 'PAUSE' : (elapsed > 0 ? 'LANJUT' : 'START')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isRunning ? Colors.amber.shade700 : AppTheme.cobalt,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: (elapsed > 0 || laps.isNotEmpty) ? service.reset : null,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('RESET'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE11D48),
                            side: const BorderSide(color: AppTheme.cloud),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Lap Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daftar Putaran (Lap)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.obsidian)),
                    if (laps.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: AppTheme.cobalt.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(999)),
                        child: Text('${laps.length} Putaran', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.cobalt)),
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
                          children: const [
                            Icon(Icons.timer_outlined, size: 44, color: AppTheme.ash),
                            SizedBox(height: 8),
                            Text('Belum ada putaran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.graphite)),
                            SizedBox(height: 4),
                            Text('Tekan tombol LAP saat stopwatch berjalan\nuntuk mencatat putaran waktu.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: AppTheme.fog)),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        decoration: BoxDecoration(
                          color: AppTheme.snow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.cloud),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            children: [
                              Container(
                                color: AppTheme.paper,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: const [
                                    SizedBox(width: 70, child: Text('No.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.fog))),
                                    Expanded(child: Text('Waktu Lap', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.fog))),
                                    SizedBox(width: 100, child: Text('Total Waktu', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.fog))),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: AppTheme.cloud),
                              Expanded(
                                child: ListView.separated(
                                  itemCount: laps.length,
                                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.cloud),
                                  itemBuilder: (context, index) {
                                    final lap = laps[index];
                                    final isFast = lap.lapNumber == fastestNum;
                                    final isSlow = lap.lapNumber == slowestNum;

                                    final Color? bg = isFast ? Colors.green.shade50.withValues(alpha: 0.5) : (isSlow ? Colors.red.shade50.withValues(alpha: 0.5) : null);
                                    final Color txt = isFast ? Colors.green.shade800 : (isSlow ? Colors.red.shade800 : AppTheme.graphite);

                                    return Container(
                                      color: bg,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 70, child: Text('Lap ${lap.lapNumber.toString().padLeft(2, '0')}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: txt))),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(StopwatchService.formatTime(lap.lapTimeMs), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: txt, fontFeatures: const [FontFeature.tabularFigures()])),
                                                if (isFast || isSlow)
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 6),
                                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                                    decoration: BoxDecoration(color: isFast ? Colors.green.shade100 : Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                                                    child: Text(isFast ? 'Tercepat' : 'Terlama', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isFast ? Colors.green.shade800 : Colors.red.shade800)),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 100, child: Text(StopwatchService.formatTime(lap.totalTimeMs), textAlign: TextAlign.right, style: const TextStyle(fontSize: 13, color: AppTheme.fog, fontFeatures: [FontFeature.tabularFigures()]))),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
