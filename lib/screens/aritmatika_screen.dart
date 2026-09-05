import 'package:flutter/material.dart';

/// Model kecil untuk satu baris input angka.
/// Diberi `id` unik (bukan sekadar index) supaya saat sebuah field
/// dihapus di tengah daftar, Flutter tidak salah mengenali widget mana
/// yang mewakili controller yang mana.
class _NumberField {
  _NumberField(this.id) : controller = TextEditingController();
  final int id;
  final TextEditingController controller;
}

class AritmatikaScreen extends StatefulWidget {
  const AritmatikaScreen({super.key});

  @override
  State<AritmatikaScreen> createState() => _AritmatikaScreenState();
}

class _AritmatikaScreenState extends State<AritmatikaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Sekarang input angka berupa daftar dinamis, bukan cuma 2 controller tetap.
  final List<_NumberField> _fields = [];
  int _nextId = 0;

  static const int _minFields = 2; // minimal 2 angka biar operasi tetap bermakna
  static const int _maxFields = 10; // batas atas supaya UI tidak kepanjangan

  String? _hasil;

  @override
  void initState() {
    super.initState();
    // Diisi langsung (tanpa setState) karena ini terjadi sebelum build pertama.
    _fields.add(_NumberField(_nextId++));
    _fields.add(_NumberField(_nextId++));
  }

  @override
  void dispose() {
    for (final f in _fields) {
      f.controller.dispose();
    }
    super.dispose();
  }

  void _tambahField() {
    if (_fields.length >= _maxFields) return;
    setState(() {
      _fields.add(_NumberField(_nextId++));
      _hasil = null;
    });
  }

  void _hapusField(int id) {
    if (_fields.length <= _minFields) return;
    setState(() {
      _fields.removeWhere((f) => f.id == id);
      _hasil = null;
    });
  }

  double? _parse(String s) => double.tryParse(s.trim().replaceAll(',', '.'));

  /// Mengubah double jadi string angka PENUH (tidak pernah dalam bentuk
  /// notasi ilmiah seperti "1e+21"), lalu titik desimalnya diganti koma
  /// supaya sesuai format Indonesia.
  String _fmt(double v) {
    if (v.isNaN) return 'tidak terdefinisi (NaN)';
    if (v.isInfinite) return v.isNegative ? '-tak hingga' : 'tak hingga';

    // Dart's toStringAsFixed() sendiri baru "lari" ke notasi ilmiah
    // begitu |v| >= 1e21. Jadi selama masih di bawah itu, aman dipakai
    // langsung untuk memastikan hasilnya selalu angka penuh.
    if (v.abs() < 1e21) {
      String s = v == v.truncateToDouble()
          ? v.toStringAsFixed(0)
          : v.toStringAsFixed(15);
      if (s.contains('.')) {
        s = s.replaceFirst(RegExp(r'0+$'), '');
        s = s.replaceFirst(RegExp(r'\.$'), '');
      }
      return s.replaceAll('.', ',');
    }

    // Untuk angka yang sangat besar (>= 1e21), Dart pasti memberi bentuk
    // eksponensial (mis. "1.23e+25"). Bentuk ini kita "bentangkan" sendiri
    // jadi digit penuh, biar tidak pernah muncul huruf "e" ke pengguna.
    return _bentangkanNotasiIlmiah(v).replaceAll('.', ',');
  }

  String _bentangkanNotasiIlmiah(double v) {
    final eksponensial = v.toStringAsExponential(); // contoh: "1.23456e+21"
    final match =
        RegExp(r'^(-?)(\d)(?:\.(\d+))?e([+-]\d+)$').firstMatch(eksponensial);
    if (match == null) return eksponensial; // fallback, seharusnya tak terjadi

    final tanda = match.group(1) ?? '';
    final digit = (match.group(2) ?? '') + (match.group(3) ?? '');
    final pangkat = int.parse(match.group(4)!);

    if (pangkat >= 0) {
      if (pangkat + 1 >= digit.length) {
        return '$tanda${digit.padRight(pangkat + 1, '0')}';
      }
      return '$tanda${digit.substring(0, pangkat + 1)}.${digit.substring(pangkat + 1)}';
    } else {
      return '${tanda}0.${'0' * (-pangkat - 1)}$digit';
    }
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasil = null);
      return;
    }

    final nilai = _fields.map((f) => _parse(f.controller.text)!).toList();

    // Penjumlahan & perkalian: urutan tidak masalah, tinggal digabung semua.
    final jumlah = nilai.reduce((a, b) => a + b);
    final kali = nilai.reduce((a, b) => a * b);

    // Pengurangan berurutan dari kiri ke kanan:
    // angka1 - angka2 - angka3 - ...
    final kurang = nilai.reduce((a, b) => a - b);

    // Pembagian berurutan dari kiri ke kanan, sambil mengecek di setiap
    // langkah apakah pembaginya nol (bisa terjadi di angka mana pun,
    // bukan cuma yang terakhir).
    String bagi;
    double berjalan = nilai.first;
    int? langkahNol;
    for (var i = 1; i < nilai.length; i++) {
      if (nilai[i] == 0) {
        langkahNol = i + 1; // posisi angka (1-based) yang bernilai nol
        break;
      }
      berjalan = berjalan / nilai[i];
    }
    bagi = langkahNol != null
        ? 'tidak terdefinisi (angka ke-$langkahNol adalah nol)'
        : _fmt(berjalan);

    setState(() {
      _hasil = 'Total Penjumlahan = ${_fmt(jumlah)}\n'
          'Total Pengurangan = ${_fmt(kurang)}\n'
          'Total Perkalian   = ${_fmt(kali)}\n'
          'Total Pembagian   = $bagi';
    });
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Aritmatika')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'OPERASI DASAR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4.0,
                        color: ink.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Kalkulasi Angka',
                      style: TextStyle(
                        fontFamily: 'InstrumentSerif',
                        fontSize: 34,
                        color: ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Minimal $_minFields angka. Tambahkan lebih banyak bila perlu.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: ink.withValues(alpha: 0.55),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Daftar field angka yang bisa bertambah/berkurang.
                    for (var i = 0; i < _fields.length; i++) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: ValueKey(_fields[i].id),
                              controller: _fields[i].controller,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                                signed: true,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Angka ke-${i + 1}',
                                hintText: 'Misal: 10 atau 2,5',
                                prefixIcon: const Icon(Icons.tag_rounded, size: 19),
                              ),
                              validator: (v) =>
                                  _parse(v ?? '') == null ? 'Harus berupa angka' : null,
                            ),
                          ),
                          if (_fields.length > _minFields)
                            IconButton(
                              tooltip: 'Hapus angka ini',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => _hapusField(_fields[i].id),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],

                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _fields.length < _maxFields ? _tambahField : null,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(
                          _fields.length < _maxFields
                              ? 'Tambah angka'
                              : 'Maksimal $_maxFields angka',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _hitung,
                        child: const Text('HITUNG'),
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (_hasil != null)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: ink.withValues(alpha: 0.16), width: 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HASIL PERHITUNGAN',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3.0,
                                color: ink.withValues(alpha: 0.45),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(color: ink.withValues(alpha: 0.10), thickness: 0.8, height: 1),
                            const SizedBox(height: 14),
                            Text(
                              _hasil!,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.8,
                                color: ink,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}