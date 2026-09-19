import 'package:flutter/material.dart';
import '../helpers/date_converter_helper.dart';
import '../theme/app_theme.dart';

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
      firstDate: DateTime(1),
      lastDate: DateTime(9999, 12, 31),
    );
    if (picked != null) {
      setState(() {
        _tanggal = picked;
        _hitung();
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

  Widget _resultBox({required String label, required String value, Widget? extra}) {
    return Container(
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
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.fog, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.cobalt, letterSpacing: -0.3),
          ),
          if (extra != null) ...[const SizedBox(height: 8), extra],
        ],
      ),
    );
  }

  Widget _chip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.snow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.cloud),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(fontSize: 12, color: AppTheme.graphite),
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(color: AppTheme.fog)),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.obsidian)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Weton & Saka Bali')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Date Picker Card
            Container(
              decoration: BoxDecoration(
                color: AppTheme.snow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cloud),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _pilihTanggal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.cobalt.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calendar_month_rounded, size: 20, color: AppTheme.cobalt),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pilih Tanggal Acuan', style: TextStyle(fontSize: 12, color: AppTheme.fog, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text('${_tanggal.day} / ${_tanggal.month} / ${_tanggal.year}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.obsidian)),
                          ],
                        ),
                      ),
                      const Icon(Icons.swap_horiz_rounded, color: AppTheme.cobalt, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 1. Weton Jawa
            _cardSection(
              icon: Icons.wb_sunny_outlined,
              title: 'Kalender Weton Jawa',
              child: _weton == null
                  ? const SizedBox.shrink()
                  : _resultBox(
                      label: 'Weton Kelahiran / Pasaran',
                      value: '${_weton!['weton']}',
                      extra: Wrap(
                        spacing: 8,
                        children: [
                          _chip('Hari', '${_weton!['hari']}'),
                          _chip('Pasaran', '${_weton!['pasaran']}'),
                          _chip('Neptu', '${_weton!['neptu']}'),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // 2. Saka Bali
            _cardSection(
              icon: Icons.calendar_month_outlined,
              title: 'Kalender Saka Bali',
              child: _sakaBali == null
                  ? const SizedBox.shrink()
                  : _resultBox(label: 'Tahun & Penataan Saka', value: _sakaBali!),
            ),
          ],
        ),
      ),
    );
  }
}
