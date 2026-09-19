import 'package:flutter/material.dart';
import '../helpers/date_converter_helper.dart';
import '../theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _hasilUmur = DateConverterHelper.hitungUmur(_tanggalLahir, DateTime.now());
    _hasilHijriah = DateConverterHelper.konversiHijriah(_tanggalMasehi);
  }

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

  Widget _cardSection({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.snow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cloud),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.cobalt.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: AppTheme.cobalt),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.obsidian),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _datePickerButton({required String label, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.paper,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.cloud),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.calendar_month_rounded, size: 18, color: AppTheme.cobalt),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.obsidian),
                ),
              ),
              const Icon(Icons.edit_calendar_rounded, size: 16, color: AppTheme.cobalt),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.snow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.cloud),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.cobalt)),
          const SizedBox(width: 4),
          Text(unit, style: const TextStyle(fontSize: 12, color: AppTheme.fog)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Umur & Hijriah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Umur
            _cardSection(
              icon: Icons.cake_outlined,
              title: 'Hitung Umur Lengkap',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _datePickerButton(
                    label: 'Tanggal Lahir: ${_tanggalLahir.day}/${_tanggalLahir.month}/${_tanggalLahir.year}',
                    onTap: _pilihTanggalLahir,
                  ),
                  if (_hasilUmur != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cobalt.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cobalt.withValues(alpha: 0.12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hasil Perhitungan Usia Presisi', style: TextStyle(fontSize: 12, color: AppTheme.fog, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _statChip('${_hasilUmur!['tahun']}', 'Tahun'),
                              _statChip('${_hasilUmur!['bulan']}', 'Bulan'),
                              _statChip('${_hasilUmur!['hari']}', 'Hari'),
                              _statChip('${_hasilUmur!['jam']}', 'Jam'),
                              _statChip('${_hasilUmur!['menit']}', 'Menit'),
                              _statChip('${_hasilUmur!['detik']}', 'Detik'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Hijriah
            _cardSection(
              icon: Icons.nights_stay_outlined,
              title: 'Konversi ke Kalender Hijriah',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _datePickerButton(
                    label: 'Tanggal Masehi: ${_tanggalMasehi.day}/${_tanggalMasehi.month}/${_tanggalMasehi.year}',
                    onTap: _pilihTanggalHijriah,
                  ),
                  if (_hasilHijriah != null) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cobalt.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.cobalt.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Hijriah', style: TextStyle(fontSize: 12, color: AppTheme.fog, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            _hasilHijriah!,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.cobalt, letterSpacing: -0.2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
