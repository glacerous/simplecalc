import 'package:flutter/material.dart';
import '../helpers/tarif_warnet.dart';

class _MenuJajanan {
  final String nama;
  final int harga;
  final IconData icon;
  final String kategori;

  const _MenuJajanan({
    required this.nama,
    required this.harga,
    required this.icon,
    required this.kategori,
  });
}

const List<_MenuJajanan> _daftarMenu = [
  _MenuJajanan(
    nama: 'Indomie (Goreng/Kuah)',
    harga: 6000,
    icon: Icons.ramen_dining,
    kategori: 'Makanan',
  ),
  _MenuJajanan(
    nama: 'Es Teh Manis',
    harga: 4000,
    icon: Icons.local_drink,
    kategori: 'Minuman',
  ),
];

class KasirScreen extends StatefulWidget {
  const KasirScreen({super.key});

  @override
  State<KasirScreen> createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  final _formKey = GlobalKey<FormState>();

  // --- Bagian Billing PC (opsional) ---
  bool _pakaiBillingPc = false;
  TipePc _tipePc = TipePc.reguler;
  final _durasiController = TextEditingController(text: '2');

  // --- Bagian Menu Jajanan & Minuman ---
  final Map<String, int> _qtyMenu = {
    'Indomie (Goreng/Kuah)': 0,
    'Es Teh Manis': 0,
  };

  final _bayarController = TextEditingController();
  int _total = 0;
  int? _kembalian;
  String? _errorDurasi;

  @override
  void dispose() {
    _durasiController.dispose();
    _bayarController.dispose();
    super.dispose();
  }

  void _increment(String nama) {
    setState(() {
      _qtyMenu[nama] = (_qtyMenu[nama] ?? 0) + 1;
      _hitungTotalOtomatis();
    });
  }

  void _decrement(String nama) {
    final current = _qtyMenu[nama] ?? 0;
    if (current > 0) {
      setState(() {
        _qtyMenu[nama] = current - 1;
        _hitungTotalOtomatis();
      });
    }
  }

  void _hitungTotalOtomatis() {
    int total = 0;
    String? errDurasi;

    if (_pakaiBillingPc) {
      final jam = int.tryParse(_durasiController.text.trim());
      if (jam == null || jam <= 0) {
        errDurasi = 'Durasi harus angka bulat lebih dari 0';
      } else {
        total += TipePc.hitungTotal(
          tipe: _tipePc,
          durasiJam: jam,
        );
      }
    }

    for (final menu in _daftarMenu) {
      final qty = _qtyMenu[menu.nama] ?? 0;
      total += menu.harga * qty;
    }

    _errorDurasi = errDurasi;
    _total = errDurasi == null ? total : 0;
    _hitungKembalian();
  }

  void _hitungKembalian() {
    final bayar = int.tryParse(_bayarController.text.trim());
    _kembalian = (bayar != null && _total > 0) ? bayar - _total : null;
  }

  void _resetTransaksi() {
    setState(() {
      _pakaiBillingPc = false;
      _tipePc = TipePc.reguler;
      _durasiController.text = '2';
      for (final menu in _daftarMenu) {
        _qtyMenu[menu.nama] = 0;
      }
      _bayarController.clear();
      _total = 0;
      _kembalian = null;
      _errorDurasi = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalBilling = _pakaiBillingPc
        ? TipePc.hitungTotal(
            tipe: _tipePc,
            durasiJam: int.tryParse(_durasiController.text.trim()) ?? 0,
          )
        : 0;

    final totalJajanan = _daftarMenu.fold<int>(
      0,
      (sum, m) => sum + (m.harga * (_qtyMenu[m.nama] ?? 0)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Warnet'),
        actions: [
          IconButton(
            tooltip: 'Reset Transaksi',
            icon: const Icon(Icons.refresh),
            onPressed: _resetTransaksi,
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Pilih paket billing dan/atau jajanan dengan sekali tap.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 12),

                  // ==================== 1. BILLING PC ====================
                  Card(
                    elevation: 1.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _pakaiBillingPc
                            ? Colors.blue.shade300
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Icon(Icons.computer,
                                    color: _pakaiBillingPc
                                        ? Colors.blue
                                        : Colors.grey.shade600),
                                const SizedBox(width: 8),
                                const Text(
                                  'Buka Billing PC',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: const Text(
                              'Aktifkan jika pelanggan main/sewa PC',
                              style: TextStyle(fontSize: 12),
                            ),
                            value: _pakaiBillingPc,
                            onChanged: (val) {
                              setState(() {
                                _pakaiBillingPc = val ?? false;
                                _hitungTotalOtomatis();
                              });
                            },
                          ),
                          if (_pakaiBillingPc) ...[
                            const Divider(),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<TipePc>(
                              initialValue: _tipePc,
                              decoration: const InputDecoration(
                                labelText: 'Tipe PC / Paket',
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
                                if (val != null) {
                                  setState(() {
                                    _tipePc = val;
                                    _hitungTotalOtomatis();
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _durasiController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Durasi Main (Jam)',
                                hintText: 'Contoh: 2',
                                border: const OutlineInputBorder(),
                                isDense: true,
                                errorText: _errorDurasi,
                              ),
                              onChanged: (_) => setState(_hitungTotalOtomatis),
                            ),
                            if (totalBilling > 0 && _errorDurasi == null) ...[
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Subtotal Billing: Rp $totalBilling',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================== 2. MENU JAJANAN & MINUMAN ====================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Menu Jajanan & Minuman',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Tap item untuk pesan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  for (final menu in _daftarMenu) ...[
                    Builder(
                      builder: (context) {
                        final qty = _qtyMenu[menu.nama] ?? 0;
                        final isSelected = qty > 0;
                        final isMinuman = menu.kategori == 'Minuman';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: isSelected ? 2 : 0.8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? Colors.blue.shade400
                                  : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          color: isSelected ? Colors.blue.shade50.withValues(alpha: 0.3) : Colors.white,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _increment(menu.nama),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  // Icon Kategori
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isMinuman
                                          ? Colors.cyan.shade50
                                          : Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      menu.icon,
                                      color: isMinuman
                                          ? Colors.cyan.shade700
                                          : Colors.orange.shade800,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Nama & Harga
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menu.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Rp ${menu.harga}',
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Counter [+] [-]
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle_outline,
                                          size: 24,
                                        ),
                                        color: qty > 0
                                            ? Colors.red.shade400
                                            : Colors.grey.shade300,
                                        onPressed: qty > 0
                                            ? () => _decrement(menu.nama)
                                            : null,
                                      ),
                                      Container(
                                        constraints:
                                            const BoxConstraints(minWidth: 26),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$qty',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: qty > 0
                                                ? Colors.blue.shade900
                                                : Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.add_circle,
                                          size: 24,
                                        ),
                                        color: Colors.green.shade600,
                                        onPressed: () =>
                                            _increment(menu.nama),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  if (totalJajanan > 0) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Subtotal Jajanan: Rp $totalJajanan',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ==================== 3. TOMBOL HITUNG & TOTAL ====================
                  ElevatedButton(
                    onPressed: () {
                      setState(_hitungTotalOtomatis);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'HITUNG TOTAL',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card Total & Pembayaran
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Transaksi:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Rp $_total',
                                style: const TextStyle(
                                  fontSize: 22,
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
                              labelText: 'Uang Pembayaran Pelanggan (Rp)',
                              prefixText: 'Rp ',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                            onChanged: (_) => setState(_hitungKembalian),
                          ),
                          if (_kembalian != null) ...[
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _kembalian! >= 0
                                    ? Colors.green.shade50
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _kembalian! >= 0
                                      ? Colors.green.shade300
                                      : Colors.red.shade300,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _kembalian! >= 0
                                        ? 'Kembalian:'
                                        : 'Status Pembayaran:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _kembalian! >= 0
                                          ? Colors.green.shade900
                                          : Colors.red.shade900,
                                    ),
                                  ),
                                  Text(
                                    _kembalian! >= 0
                                        ? 'Rp $_kembalian'
                                        : 'Kurang Rp ${-_kembalian!}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _kembalian! >= 0
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                    ),
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}
