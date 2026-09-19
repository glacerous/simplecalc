import 'package:flutter/material.dart';
import '../helpers/tarif_warnet.dart';

/// Satu baris belanja: nama barang (opsional) + harga satuan + qty.
class _ItemBelanja {
  _ItemBelanja(this.id)
      : namaController = TextEditingController(),
        hargaController = TextEditingController(),
        qtyController = TextEditingController(text: '1');
  final int id;
  final TextEditingController namaController;
  final TextEditingController hargaController;
  final TextEditingController qtyController;

  void dispose() {
    namaController.dispose();
    hargaController.dispose();
    qtyController.dispose();
  }
}

/// Kasir Warnet Pojok — satu transaksi bisa berisi sewa PC (opsional) DAN
/// jajanan/minuman (opsional, dinamis). Sebelumnya ini dua kalkulator
/// terpisah (Biaya Sewa & Aritmatika/Kasir) yang masing-masing punya
/// total+bayar+kembalian sendiri — digabung karena kasir beneran memang
/// menjumlahkan semuanya jadi satu nota, bukan dua transaksi terpisah.
class KasirScreen extends StatefulWidget {
  const KasirScreen({super.key});

  @override
  State<KasirScreen> createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- Bagian sewa PC (opsional) ---
  bool _pakaiSewaPc = false;
  TipePc _tipePc = TipePc.reguler;
  final _durasiController = TextEditingController(text: '2');
  bool _tambahEsTeh = false;

  // --- Bagian jajanan/minuman (dinamis, opsional) ---
  final List<_ItemBelanja> _items = [];
  int _nextId = 0;
  static const int _maxItems = 10;

  final _bayarController = TextEditingController();
  int _total = 0;
  int? _kembalian;
  String? _errorDurasi;

  @override
  void dispose() {
    _durasiController.dispose();
    _bayarController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _tambahItem() {
    if (_items.length >= _maxItems) return;
    setState(() => _items.add(_ItemBelanja(_nextId++)));
  }

  void _hapusItem(int id) {
    setState(() {
      _items.removeWhere((item) {
        if (item.id == id) {
          item.dispose();
          return true;
        }
        return false;
      });
    });
  }

  void _hitungTotal() {
    if (!_formKey.currentState!.validate()) return;

    int total = 0;
    String? errDurasi;

    if (_pakaiSewaPc) {
      final jam = int.tryParse(_durasiController.text.trim());
      if (jam == null || jam <= 0) {
        errDurasi = 'Durasi harus angka bulat lebih dari 0';
      } else {
        total += TipePc.hitungTotal(
          tipe: _tipePc,
          durasiJam: jam,
          tambahEsTeh: _tambahEsTeh,
        );
      }
    }

    for (final item in _items) {
      final harga = int.tryParse(item.hargaController.text.trim()) ?? 0;
      final qty = int.tryParse(item.qtyController.text.trim()) ?? 0;
      total += harga * qty;
    }

    setState(() {
      _errorDurasi = errDurasi;
      _total = errDurasi == null ? total : 0;
      _hitungKembalian();
    });
  }

  void _hitungKembalian() {
    final bayar = int.tryParse(_bayarController.text.trim());
    setState(() {
      _kembalian = (bayar != null && _total > 0) ? bayar - _total : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kasir Warnet')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Satu transaksi bisa berisi sewa PC dan/atau jajanan.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  // --- Sewa PC ---
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              'Termasuk sewa PC',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            value: _pakaiSewaPc,
                            onChanged: (val) =>
                                setState(() => _pakaiSewaPc = val ?? false),
                          ),
                          if (_pakaiSewaPc) ...[
                            const SizedBox(height: 4),
                            DropdownButtonFormField<TipePc>(
                              initialValue: _tipePc,
                              decoration: const InputDecoration(
                                labelText: 'Tipe PC',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: TipePc.values
                                  .map((t) => DropdownMenuItem(
                                        value: t,
                                        child: Text(t.labelDenganTarif),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _tipePc = val);
                              },
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _durasiController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Durasi (Jam)',
                                border: const OutlineInputBorder(),
                                isDense: true,
                                errorText: _errorDurasi,
                              ),
                            ),
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Tambah Es Teh Manis (+ Rp 4.000)',
                              ),
                              value: _tambahEsTeh,
                              onChanged: (val) =>
                                  setState(() => _tambahEsTeh = val ?? false),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Jajanan/minuman ---
                  const Text(
                    'Jajanan / Minuman',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  for (final item in _items)
                    Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    key: ValueKey('nama_${item.id}'),
                                    controller: item.namaController,
                                    decoration: const InputDecoration(
                                      labelText: 'Nama barang (opsional)',
                                      hintText: 'Misal: Mie Instan',
                                      isDense: true,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Hapus item ini',
                                  icon: const Icon(Icons.close_rounded, size: 20),
                                  onPressed: () => _hapusItem(item.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    key: ValueKey('harga_${item.id}'),
                                    controller: item.hargaController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Harga satuan',
                                      prefixText: 'Rp ',
                                      isDense: true,
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return null;
                                      final n = int.tryParse(v.trim());
                                      if (n == null) return 'Wajib angka';
                                      if (n < 0) return 'Tidak boleh negatif';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    key: ValueKey('qty_${item.id}'),
                                    controller: item.qtyController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'Qty',
                                      isDense: true,
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) return null;
                                      final n = int.tryParse(v.trim());
                                      if (n == null) return 'Wajib angka';
                                      if (n <= 0) return 'Min 1';
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _items.length < _maxItems ? _tambahItem : null,
                      icon: const Icon(Icons.add_rounded),
                      label: Text(
                        _items.length < _maxItems
                            ? 'Tambah item'
                            : 'Maksimal $_maxItems item',
                      ),
                    ),
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
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Belanja:', style: TextStyle(fontSize: 16)),
                              Text(
                                'Rp $_total',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
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
                                  _kembalian! >= 0
                                      ? 'Rp $_kembalian'
                                      : 'Uang Kurang Rp ${-_kembalian!}',
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
          ),
        ),
      ),
    );
  }
}
