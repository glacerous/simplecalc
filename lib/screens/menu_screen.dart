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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('simplecalc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 20),
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
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              children: [
                // Header section
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
                    fontWeight: FontWeight.w400,
                    color: ink,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 28),

                // Menu items
                _MenuCard(
                  number: '01',
                  icon: Icons.groups_outlined,
                  title: 'Data Kelompok',
                  subtitle: 'Informasi anggota tim',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const DataKelompokScreen()),
                  ),
                ),
                _MenuCard(
                  number: '02',
                  icon: Icons.calculate_outlined,
                  title: 'Aritmatika',
                  subtitle: 'Tambah, kurang, kali, bagi',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AritmatikaScreen()),
                  ),
                ),
                _MenuCard(
                  number: '03',
                  icon: Icons.filter_2_outlined,
                  title: 'Ganjil / Genap',
                  subtitle: 'Pengecekan paritas bilangan',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GanjilGenapScreen()),
                  ),
                ),
                _MenuCard(
                  number: '04',
                  icon: Icons.summarize_outlined,
                  title: 'Jumlah Total Angka',
                  subtitle: 'Penjumlahan deret data',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const JumlahTotalScreen()),
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

class _MenuCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: ink.withValues(alpha: 0.14),
          width: 0.9,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                number,
                style: TextStyle(
                  fontFamily: 'InstrumentSerif',
                  fontSize: 20,
                  color: ink.withValues(alpha: 0.35),
                ),
              ),
              const SizedBox(width: 16),
              Icon(icon, color: ink, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'InstrumentSerif',
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        color: ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: ink.withValues(alpha: 0.50),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: ink.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
