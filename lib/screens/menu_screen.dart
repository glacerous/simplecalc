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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(
            icon: Icons.groups,
            title: 'Data Kelompok',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DataKelompokScreen()),
            ),
          ),
          _MenuCard(
            icon: Icons.calculate,
            title: 'Penjumlahan, Pengurangan, Perkalian, Pembagian',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AritmatikaScreen()),
            ),
          ),
          _MenuCard(
            icon: Icons.filter_2,
            title: 'Cek Bilangan Ganjil/Genap',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const GanjilGenapScreen()),
            ),
          ),
          _MenuCard(
            icon: Icons.summarize,
            title: 'Jumlah Total Angka',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const JumlahTotalScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.red, size: 32),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
