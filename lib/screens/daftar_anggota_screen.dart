import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DaftarAnggotaScreen extends StatelessWidget {
  const DaftarAnggotaScreen({super.key});

  final List<Map<String, String>> members = const [
    {'nama': 'Azzaky', 'nim': '124240018'},
    {'nama': 'Gilang', 'nim': '124240056'},
    {'nama': 'Pindo', 'nim': '124240031'},
    {'nama': 'Lintang', 'nim': '124240009'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Anggota Kelompok',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.obsidian,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Sistem Informasi - UPN "Veteran" Yogyakarta',
            style: TextStyle(color: AppTheme.fog, fontSize: 13),
          ),
          const SizedBox(height: 18),
          ...members.map((m) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppTheme.snow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cloud, width: 1),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.cobalt.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cobalt.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    m['nama']![0],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.cobalt,
                    ),
                  ),
                ),
                title: Text(
                  m['nama']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppTheme.obsidian,
                  ),
                ),
                subtitle: Text(
                  'NIM: ${m['nim']}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.fog,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
