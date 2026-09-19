import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'daftar_anggota_screen.dart';
import 'kasir_screen.dart';
import 'warnet_crud_screen.dart';
import 'konversi_umur_hijriah_screen.dart';
import 'konversi_weton_saka_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static final List<Map<String, dynamic>> _menus = [
    {
      'title': '1. Daftar Anggota',
      'sub': 'Informasi pengembang & kelompok',
      'icon': Icons.group_outlined,
      'screen': const DaftarAnggotaScreen(),
    },
    {
      'title': '2. Kasir Warnet',
      'sub': 'Billing PC & pesanan jajanan/minuman',
      'icon': Icons.point_of_sale_outlined,
      'screen': const KasirScreen(),
    },
    {
      'title': '3. Kelola Sesi (CRUD)',
      'sub': 'Manajemen riwayat sesi rental SQLite',
      'icon': Icons.storage_outlined,
      'screen': const WarnetCrudScreen(),
    },
    {
      'title': '4. Konversi Umur & Hijriah',
      'sub': 'Perhitungan usia dan penanggalan Islam',
      'icon': Icons.calendar_month_outlined,
      'screen': const KonversiUmurHijriahScreen(),
    },
    {
      'title': '5. Konversi Weton & Saka Bali',
      'sub': 'Kalkulasi hari pasaran & kalender Saka',
      'icon': Icons.event_note_outlined,
      'screen': const KonversiWetonSakaScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warnet Pojok')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Menu Utama', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.obsidian, letterSpacing: -0.5)),
                const SizedBox(height: 4),
                const Text('Pilih modul operasional warnet yang ingin dijalankan.', style: TextStyle(fontSize: 14, color: AppTheme.fog)),
                const SizedBox(height: 20),
                for (final item in _menus)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.snow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cloud),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item['screen'] as Widget)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppTheme.cobalt.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppTheme.cobalt.withValues(alpha: 0.15)),
                              ),
                              child: Icon(item['icon'] as IconData, size: 22, color: AppTheme.cobalt),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.obsidian)),
                                  const SizedBox(height: 2),
                                  Text(item['sub'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.fog)),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.ash),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
