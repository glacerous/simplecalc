import 'package:flutter/material.dart';
import '../helpers/date_converter_helper.dart';

class KonversiUmurHijriahScreen extends StatefulWidget {
  const KonversiUmurHijriahScreen({super.key});

  @override
  State<KonversiUmurHijriahScreen> createState() => _KonversiUmurHijriahScreenState();
}

class _KonversiUmurHijriahScreenState extends State<KonversiUmurHijriahScreen> {
  DateTime _tanggalLahir = DateTime(2003, 1, 1);
  Map<String, int>? _hasilUmur;

  DateTime _tanggalMasehi = DateTime.now();
  String? _hasilHijriah;

  void _pilihTanggalLahir() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _tanggalLahir = picked;
        _hasilUmur = DateConverterHelper.hitungUmur(_tanggalLahir, DateTime.now());
      });
    }
  }

  void _pilihTanggalHijriah() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMasehi,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        _tanggalMasehi = picked;
        _hasilHijriah = DateConverterHelper.konversiHijriah(_tanggalMasehi);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _hasilUmur = DateConverterHelper.hitungUmur(_tanggalLahir, DateTime.now());
    _hasilHijriah = DateConverterHelper.konversiHijriah(_tanggalMasehi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konversi Umur & Hijriah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Konversi Tanggal Lahir ke Umur
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hitung Umur Lengkap',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month),
                      label: Text(
                        'Pilih Tanggal Lahir: ${_tanggalLahir.day}/${_tanggalLahir.month}/${_tanggalLahir.year}',
                      ),
                      onPressed: _pilihTanggalLahir,
                    ),
                    const SizedBox(height: 12),
                    if (_hasilUmur != null) ...[
                      Text(
                        'Umur Anda:\n'
                        '• ${_hasilUmur!['tahun']} Tahun\n'
                        '• ${_hasilUmur!['bulan']} Bulan\n'
                        '• ${_hasilUmur!['hari']} Hari\n'
                        '• ${_hasilUmur!['jam']} Jam\n'
                        '• ${_hasilUmur!['menit']} Menit\n'
                        '• ${_hasilUmur!['detik']} Detik',
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Konversi Kalender Hijriah
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Konversi ke Kalender Hijriah',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        'Pilih Tanggal: ${_tanggalMasehi.day}/${_tanggalMasehi.month}/${_tanggalMasehi.year}',
                      ),
                      onPressed: _pilihTanggalHijriah,
                    ),
                    const SizedBox(height: 12),
                    if (_hasilHijriah != null) ...[
                      Text(
                        'Tanggal Hijriah:\n$_hasilHijriah',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
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
