import 'package:flutter/material.dart';
import '../helpers/date_converter_helper.dart';

class KonversiWetonSakaScreen extends StatefulWidget {
  const KonversiWetonSakaScreen({super.key});

  @override
  State<KonversiWetonSakaScreen> createState() => _KonversiWetonSakaScreenState();
}

class _KonversiWetonSakaScreenState extends State<KonversiWetonSakaScreen> {
  DateTime _tanggal = DateTime.now();
  Map<String, dynamic>? _weton;
  String? _sakaBali;

  @override
  void initState() {
    super.initState();
    _hitung();
  }

  void _hitung() {
    setState(() {
      _weton = DateConverterHelper.konversiWeton(_tanggal);
      _sakaBali = DateConverterHelper.konversiSakaBali(_tanggal);
    });
  }

  void _pilihTanggal() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        _tanggal = picked;
        _hitung();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Weton & Saka Bali'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_month),
              label: Text(
                'Pilih Tanggal: ${_tanggal.day}/${_tanggal.month}/${_tanggal.year}',
              ),
              onPressed: _pilihTanggal,
            ),
            const SizedBox(height: 20),

            // 1. Kalender Weton
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kalender Weton Jawa',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_weton != null) ...[
                      Text(
                        'Weton: ${_weton!['weton']}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hari: ${_weton!['hari']} • Pasaran: ${_weton!['pasaran']} • Neptu: ${_weton!['neptu']}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Kalender Saka Bali
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kalender Saka Bali',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (_sakaBali != null) ...[
                      Text(
                        _sakaBali!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
