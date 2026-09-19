import 'package:flutter/material.dart';
import '../helpers/session_manager.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan & Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Petunjuk Penggunaan Aplikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. Halaman Utama', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Berisi 5 menu utama: Daftar Anggota, Kasir Warnet (sewa PC + jajanan), Kelola Sesi (CRUD), Konversi Umur & Hijriah, serta Konversi Weton & Saka Bali.'),
                  SizedBox(height: 8),
                  Text('2. Stopwatch', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Digunakan untuk menghitung durasi waktu secara presisi dengan fitur Start, Pause, Reset, dan Catat Putaran (Lap). Stopwatch tetap aktif berjalan meskipun Anda berpindah tab menu.'),
                  SizedBox(height: 8),
                  Text('3. Database & Session', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Aplikasi menggunakan SQLite untuk menyimpan data sewa PC dan SharedPreferences untuk session login.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('LOGOUT'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
