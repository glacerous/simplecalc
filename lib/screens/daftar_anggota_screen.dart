import 'package:flutter/material.dart';

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
        title: const Text('Daftar Anggota Kelompok'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Anggota Kelompok',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sistem Informasi - UPN "Veteran" Yogyakarta',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...members.map((m) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              elevation: 1.5,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    m['nama']![0],
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                title: Text(m['nama']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('NIM: ${m['nim']}'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
