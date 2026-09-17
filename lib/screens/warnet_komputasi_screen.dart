import 'package:flutter/material.dart';

class WarnetKomputasiScreen extends StatefulWidget {
  const WarnetKomputasiScreen({super.key});

  @override
  State<WarnetKomputasiScreen> createState() => _WarnetKomputasiScreenState();
}

class _WarnetKomputasiScreenState extends State<WarnetKomputasiScreen> {
  String _tipePc = 'Reguler (Rp 4.000/jam)';
  final _durasiController = TextEditingController(text: '2');
  final _bayarController = TextEditingController();

  bool _tambahMinum = false;
  int _totalBiaya = 0;
  int? _kembalian;

  @override
  void dispose() {
    _durasiController.dispose();
    _bayarController.dispose();
    super.dispose();
  }

  void _hitungTotal() {
    int tarif = _tipePc.startsWith('Reguler') ? 4000 : 7000;
    int jam = int.tryParse(_durasiController.text) ?? 0;

    int total = tarif * jam;
    if (_tambahMinum) {
      total += 4000; // Es Teh Rp 4.000
    }

    setState(() {
      _totalBiaya = total;
      _hitungKembalian();
    });
  }

  void _hitungKembalian() {
    final bayar = int.tryParse(_bayarController.text);
    if (bayar != null && _totalBiaya > 0) {
      setState(() {
        _kembalian = bayar - _totalBiaya;
      });
    } else {
      setState(() {
        _kembalian = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Komputasi Tarif Billing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Kalkulator Billing Warnet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Pilihan Tipe PC
            DropdownButtonFormField<String>(
              value: _tipePc,
              decoration: const InputDecoration(
                labelText: 'Pilih Tipe PC',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Reguler (Rp 4.000/jam)',
                  child: Text('PC Reguler (Rp 4.000/jam)'),
                ),
                DropdownMenuItem(
                  value: 'VIP (Rp 7.000/jam)',
                  child: Text('PC VIP (Rp 7.000/jam)'),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _tipePc = val);
              },
            ),
            const SizedBox(height: 16),

            // Input Durasi
            TextField(
              controller: _durasiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Durasi Sewa (Jam)',
                border: OutlineInputBorder(),
                suffixText: 'Jam',
              ),
            ),
            const SizedBox(height: 12),

            // Checkbox Minuman
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Tambah Es Teh Manis (+ Rp 4.000)'),
              value: _tambahMinum,
              onChanged: (val) {
                setState(() => _tambahMinum = val ?? false);
              },
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _hitungTotal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('HITUNG TOTAL'),
            ),
            const SizedBox(height: 24),

            // Card Hasil
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Biaya:', style: TextStyle(fontSize: 16)),
                        Text(
                          'Rp $_totalBiaya',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    TextField(
                      controller: _bayarController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Uang Pembayaran (Rp)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _hitungKembalian(),
                    ),
                    if (_kembalian != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Kembalian:', style: TextStyle(fontSize: 16)),
                          Text(
                            _kembalian! >= 0 ? 'Rp $_kembalian' : 'Uang Kurang Rp ${-_kembalian!}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _kembalian! >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
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
