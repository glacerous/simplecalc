import 'package:flutter/material.dart';
import '../helpers/session_manager.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class BantuanScreen extends StatelessWidget {
  const BantuanScreen({super.key});

  void _logout(BuildContext context) async {
    await SessionManager.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  static const List<Map<String, String>> _guides = [
    {
      'num': '1',
      'title': 'Halaman Utama',
      'desc': 'Berisi 5 modul: Daftar Anggota, Kasir Warnet (billing PC + jajanan siap-tap), Kelola Sesi (CRUD SQLite), Konversi Umur & Hijriah, serta Konversi Weton & Saka Bali.',
    },
    {
      'num': '2',
      'title': 'Stopwatch Presisi',
      'desc': 'Menghitung waktu dengan resolusi centisecond, kontrol Start/Pause/Reset, dan pencatatan waktu putaran (Lap) yang tetap berjalan aktif di background saat berpindah tab.',
    },
    {
      'num': '3',
      'title': 'Penyimpanan & Sesi',
      'desc': 'Data transaksi sesi tersimpan di SQLite lokal dan status login pengguna dikelola via SharedPreferences.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bantuan & Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Petunjuk Penggunaan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.obsidian, letterSpacing: -0.4)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.snow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.cloud),
            ),
            child: Column(
              children: _guides.map((g) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.cobalt.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(g['num']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.cobalt)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g['title']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.obsidian)),
                            const SizedBox(height: 3),
                            Text(g['desc']!, style: const TextStyle(fontSize: 13, color: AppTheme.fog, height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text('LOGOUT DARI SISTEM'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE11D48),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
