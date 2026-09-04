import 'package:flutter/material.dart';

class DataKelompokScreen extends StatelessWidget {
  const DataKelompokScreen({super.key});

  Widget _row(String label, String value, Color ink) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
                color: ink.withValues(alpha: 0.45),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 13, color: ink),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    final members = [
      {'nama': 'Gilang', 'nim': '124240056', 'prodi': 'Sistem Informasi', 'kampus': 'UPN Veteran Yogyakarta'},
      {'nama': 'Pindo', 'nim': '124240031', 'prodi': 'Sistem Informasi', 'kampus': 'UPN Veteran Yogyakarta'},
      {'nama': 'Azzaky', 'nim': '124240018', 'prodi': 'Sistem Informasi', 'kampus': 'UPN Veteran Yogyakarta'},
      {'nama': 'Lintang', 'nim': '124240009', 'prodi': 'Sistem Informasi', 'kampus': 'UPN Veteran Yogyakarta'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Data Kelompok')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                Text(
                  'ANGGOTA TIM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4.0,
                    color: ink.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Daftar Mahasiswa',
                  style: TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontSize: 34,
                    color: ink,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),

                ...members.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final m = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ink.withValues(alpha: 0.14), width: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              m['nama']!,
                              style: const TextStyle(
                                fontFamily: 'InstrumentSerif',
                                fontSize: 24,
                                color: ink,
                              ),
                            ),
                            Text(
                              '0$idx',
                              style: TextStyle(
                                fontFamily: 'InstrumentSerif',
                                fontSize: 18,
                                color: ink.withValues(alpha: 0.35),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(color: ink.withValues(alpha: 0.10), thickness: 0.8, height: 1),
                        const SizedBox(height: 8),
                        _row('NIM', m['nim']!, ink),
                        _row('PRODI', m['prodi']!, ink),
                        _row('KAMPUS', m['kampus']!, ink),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
