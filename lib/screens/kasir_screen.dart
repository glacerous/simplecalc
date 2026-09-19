import 'package:flutter/material.dart';
import '../helpers/tarif_warnet.dart';
import '../theme/app_theme.dart';

class _MenuJajanan {
  final String nama;
  final int harga;
  final IconData icon;
  const _MenuJajanan({required this.nama, required this.harga, required this.icon});
}

const List<_MenuJajanan> _daftarMenu = [
  _MenuJajanan(nama: 'Indomie (Goreng/Kuah)', harga: 6000, icon: Icons.ramen_dining_rounded),
  _MenuJajanan(nama: 'Es Teh Manis', harga: 4000, icon: Icons.local_drink_rounded),
];

class KasirScreen extends StatefulWidget {
  const KasirScreen({super.key});

  @override
  State<KasirScreen> createState() => _KasirScreenState();
}

class _KasirScreenState extends State<KasirScreen> {
  bool _pakaiBillingPc = false;
  TipePc _tipePc = TipePc.reguler;
  final _durasiController = TextEditingController(text: '2');
  final _bayarController = TextEditingController();
  final Map<String, int> _qtyMenu = {'Indomie (Goreng/Kuah)': 0, 'Es Teh Manis': 0};

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
    String? err;

    if (_pakaiBillingPc) {
      final jam = int.tryParse(_durasiController.text.trim());
      if (jam == null || jam <= 0) {
        err = 'Durasi harus angka bulat lebih dari 0';
      } else {
        total += TipePc.hitungTotal(tipe: _tipePc, durasiJam: jam);
      }
    }

    for (final m in _daftarMenu) {
      total += m.harga * (_qtyMenu[m.nama] ?? 0);
    }

    _errorDurasi = err;
    _total = err == null ? total : 0;
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
      for (final m in _daftarMenu) {
        _qtyMenu[m.nama] = 0;
      }
      _bayarController.clear();
      _total = 0;
      _kembalian = null;
      _errorDurasi = null;
    });
  }

  Widget _buildMenuItem(_MenuJajanan menu) {
    final qty = _qtyMenu[menu.nama] ?? 0;
    final isSelected = qty > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.cobalt.withValues(alpha: 0.04) : AppTheme.snow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppTheme.cobalt : AppTheme.cloud,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _increment(menu.nama),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.cobalt.withValues(alpha: 0.1) : AppTheme.paper,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppTheme.cobalt.withValues(alpha: 0.2) : AppTheme.cloud,
                  ),
                ),
                child: Icon(menu.icon, color: isSelected ? AppTheme.cobalt : AppTheme.obsidian, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(menu.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.obsidian)),
                    const SizedBox(height: 2),
                    Text('Rp ${menu.harga}', style: const TextStyle(color: AppTheme.fog, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 22),
                color: qty > 0 ? const Color(0xFFE11D48) : AppTheme.ash,
                onPressed: qty > 0 ? () => _decrement(menu.nama) : null,
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 24),
                alignment: Alignment.center,
                child: Text('$qty', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: qty > 0 ? AppTheme.cobalt : AppTheme.ash)),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_rounded, size: 22),
                color: isSelected ? AppTheme.cobalt : AppTheme.obsidian,
                onPressed: () => _increment(menu.nama),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalBilling = _pakaiBillingPc
        ? TipePc.hitungTotal(tipe: _tipePc, durasiJam: int.tryParse(_durasiController.text.trim()) ?? 0)
        : 0;
    final totalJajanan = _daftarMenu.fold<int>(0, (sum, m) => sum + (m.harga * (_qtyMenu[m.nama] ?? 0)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kasir Warnet'),
        actions: [
          IconButton(tooltip: 'Reset Transaksi', icon: const Icon(Icons.refresh_rounded), onPressed: _resetTransaksi),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. BILLING PC
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.snow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.cloud),
                  ),
                  child: Column(
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          children: [
                            Icon(Icons.computer_rounded, size: 20, color: _pakaiBillingPc ? AppTheme.cobalt : AppTheme.fog),
                            const SizedBox(width: 8),
                            const Text('Buka Billing PC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.obsidian)),
                          ],
                        ),
                        subtitle: const Text('Aktifkan jika pelanggan main/sewa PC', style: TextStyle(fontSize: 12, color: AppTheme.fog)),
                        value: _pakaiBillingPc,
                        activeColor: AppTheme.cobalt,
                        onChanged: (v) => setState(() {
                          _pakaiBillingPc = v ?? false;
                          _hitungTotalOtomatis();
                        }),
                      ),
                      if (_pakaiBillingPc) ...[
                        const Divider(color: AppTheme.cloud),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<TipePc>(
                          initialValue: _tipePc,
                          decoration: const InputDecoration(labelText: 'Tipe PC / Paket'),
                          items: TipePc.values.map((t) => DropdownMenuItem(value: t, child: Text(t.labelDenganTarif))).toList(),
                          onChanged: (v) {
                            if (v != null) setState(() { _tipePc = v; _hitungTotalOtomatis(); });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _durasiController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Durasi Main (Jam)', hintText: 'Contoh: 2', errorText: _errorDurasi),
                          onChanged: (_) => setState(_hitungTotalOtomatis),
                        ),
                        if (totalBilling > 0 && _errorDurasi == null) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('Subtotal Billing: Rp $totalBilling', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.obsidian)),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 2. MENU JAJANAN & MINUMAN
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Menu Jajanan & Minuman', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.obsidian)),
                    Text('Tap item untuk pesan', style: TextStyle(fontSize: 12, color: AppTheme.fog)),
                  ],
                ),
                const SizedBox(height: 8),
                for (final menu in _daftarMenu) _buildMenuItem(menu),
                if (totalJajanan > 0) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Subtotal Jajanan: Rp $totalJajanan', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.obsidian)),
                  ),
                ],
                const SizedBox(height: 14),

                // 3. HITUNG TOTAL & PEMBAYARAN
                ElevatedButton(
                  onPressed: () => setState(_hitungTotalOtomatis),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.obsidian, foregroundColor: Colors.white),
                  child: const Text('HITUNG TOTAL', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.snow,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.cloud),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Transaksi:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.fog)),
                          Text('Rp $_total', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.cobalt, letterSpacing: -0.5)),
                        ],
                      ),
                      const Divider(height: 24, color: AppTheme.cloud),
                      TextField(
                        controller: _bayarController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Uang Pembayaran Pelanggan (Rp)', prefixText: 'Rp '),
                        onChanged: (_) => setState(_hitungKembalian),
                      ),
                      if (_kembalian != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: _kembalian! >= 0 ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _kembalian! >= 0 ? Colors.green.shade300 : Colors.red.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _kembalian! >= 0 ? 'Kembalian:' : 'Status Pembayaran:',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _kembalian! >= 0 ? Colors.green.shade900 : Colors.red.shade900),
                              ),
                              Text(
                                _kembalian! >= 0 ? 'Rp $_kembalian' : 'Kurang Rp ${-_kembalian!}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _kembalian! >= 0 ? Colors.green.shade800 : Colors.red.shade800),
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
        ),
      ),
    );
  }
}
