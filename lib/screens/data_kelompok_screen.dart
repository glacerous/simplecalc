import 'package:flutter/material.dart';

class DataKelompokScreen extends StatelessWidget {
  const DataKelompokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kelompok')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _InfoRow(label: 'Nama', value: 'Gilang'),
                _InfoRow(label: 'NIM', value: '124240056'),
                _InfoRow(label: 'Prodi', value: 'Sistem Informasi'),
                _InfoRow(label: 'Kampus', value: 'UPN Veteran Yogyakarta'),
                SizedBox(height: 5),
                _InfoRow(label: 'Nama', value: 'Pindo'),
                _InfoRow(label: 'NIM', value: '124240031'),
                _InfoRow(label: 'Prodi', value: 'Sistem Informasi'),
                _InfoRow(label: 'Kampus', value: 'UPN Veteran Yogyakarta'),
                SizedBox(height: 5),
                _InfoRow(label: 'Nama', value: 'Azzaky'),
                _InfoRow(label: 'NIM', value: '124240018'),
                _InfoRow(label: 'Prodi', value: 'Sistem Informasi'),
                _InfoRow(label: 'Kampus', value: 'UPN Veteran Yogyakarta'),
                SizedBox(height: 5),
                _InfoRow(label: 'Nama', value: 'Lintang'),
                _InfoRow(label: 'NIM', value: '124240009'),
                _InfoRow(label: 'Prodi', value: 'Sistem Informasi'),
                _InfoRow(label: 'Kampus', value: 'UPN Veteran Yogyakarta'),
                // Tambahkan anggota kelompok lain di sini kalau perlu
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
