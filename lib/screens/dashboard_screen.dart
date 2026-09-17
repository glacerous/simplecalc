import 'package:flutter/material.dart';
import 'daftar_anggota_screen.dart';
import 'warnet_komputasi_screen.dart';
import 'warnet_crud_screen.dart';
import 'konversi_umur_hijriah_screen.dart';
import 'konversi_weton_saka_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget _menuButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Widget targetScreen,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          alignment: Alignment.centerLeft,
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade900,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.blue.shade200),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetScreen),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warnet Pojok - Menu Utama'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'PILIHAN MENU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),

                // 1. Daftar Anggota
                _menuButton(
                  context: context,
                  text: '1. Daftar Anggota',
                  icon: Icons.group,
                  targetScreen: const DaftarAnggotaScreen(),
                ),

                // 2. Komputasi Tema
                _menuButton(
                  context: context,
                  text: '2. Komputasi Tarif Warnet',
                  icon: Icons.calculate,
                  targetScreen: const WarnetKomputasiScreen(),
                ),

                // 3. CRUD Tema
                _menuButton(
                  context: context,
                  text: '3. Kelola Sewa PC (CRUD)',
                  icon: Icons.table_chart,
                  targetScreen: const WarnetCrudScreen(),
                ),

                // 4. Konversi Umur & Hijriah
                _menuButton(
                  context: context,
                  text: '4. Konversi Umur & Hijriah',
                  icon: Icons.calendar_today,
                  targetScreen: const KonversiUmurHijriahScreen(),
                ),

                // 5. Konversi Weton & Saka Bali
                _menuButton(
                  context: context,
                  text: '5. Konversi Weton & Saka Bali',
                  icon: Icons.event,
                  targetScreen: const KonversiWetonSakaScreen(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
