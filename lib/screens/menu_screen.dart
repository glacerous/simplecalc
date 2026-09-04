import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'data_kelompok_screen.dart';
import 'aritmatika_screen.dart';
import 'ganjil_genap_screen.dart';
import 'jumlah_total_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    final menus = [
      (
        '01',
        Icons.groups_outlined,
        'Data Kelompok',
        'Informasi anggota tim',
        const DataKelompokScreen(),
      ),
      (
        '02',
        Icons.calculate_outlined,
        'Aritmatika',
        'Tambah, kurang, kali, bagi',
        const AritmatikaScreen(),
      ),
      (
        '03',
        Icons.filter_2_outlined,
        'Ganjil / Genap',
        'Pengecekan paritas bilangan',
        const GanjilGenapScreen(),
      ),
      (
        '04',
        Icons.summarize_outlined,
        'Jumlah Total Angka',
        'Penjumlahan deret data',
        const JumlahTotalScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('simplecalc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                Text(
                  'MENU UTAMA',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4.0,
                    color: ink.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pilih Operasi',
                  style: TextStyle(
                    fontFamily: 'InstrumentSerif',
                    fontSize: 34,
                    color: ink,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 28),

                ...menus.map((item) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ink.withValues(alpha: 0.14), width: 0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      leading: Text(
                        item.$1,
                        style: TextStyle(
                          fontFamily: 'InstrumentSerif',
                          fontSize: 20,
                          color: ink.withValues(alpha: 0.35),
                        ),
                      ),
                      title: Text(
                        item.$3,
                        style: const TextStyle(
                          fontFamily: 'InstrumentSerif',
                          fontSize: 22,
                          color: ink,
                        ),
                      ),
                      subtitle: Text(
                        item.$4,
                        style: TextStyle(fontSize: 12, color: ink.withValues(alpha: 0.50)),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: ink.withValues(alpha: 0.35),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => item.$5),
                      ),
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
