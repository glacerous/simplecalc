import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Model kecil untuk satu baris input angka.
/// Diberi `id` unik (bukan sekadar index) supaya saat sebuah field
/// dihapus di tengah daftar, Flutter tidak salah mengenali widget mana
/// yang mewakili controller yang mana.
class _NumberField {
  _NumberField(this.id) : controller = TextEditingController();
  final int id;
  final TextEditingController controller;
}

/// Mencegah user mengetik lebih dari satu simbol desimal dalam satu field,
/// baik koma maupun titik, atau campuran keduanya (mis. "1,2.3" atau "1..2"
/// atau "1,,2" semua ditolak). Begitu sudah ada satu simbol (apapun jenisnya),
/// percobaan menambah simbol kedua ditolak, balik ke nilai sebelumnya.
class _SingleDecimalSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final jumlahSeparator =
        RegExp(r'[.,]').allMatches(newValue.text).length;
    if (jumlahSeparator > 1) {
      return oldValue;
    }
    return newValue;
  }
}

class AritmatikaScreen extends StatefulWidget {
  const AritmatikaScreen({super.key});

  @override
  State<AritmatikaScreen> createState() => _AritmatikaScreenState();
}

class _AritmatikaScreenState extends State<AritmatikaScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<_NumberField> _fields = [];
  int _nextId = 0;

  static const int _minFields = 2;
  static const int _maxFields = 10;

  String? _hasil;

  @override
  void initState() {
    super.initState();
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

  double? _parse(String s) {
    final t = s.trim().replaceAll(',', '.');
    if (!RegExp(r'^-?[0-9]+(\.[0-9]+)?$').hasMatch(t)) return null;
    return double.tryParse(t);
  }

  String _fmt(double v) {
    if (v.isNaN) return 'tidak terdefinisi';
    if (v.isInfinite) return 'tak hingga';

    String s = v.toString();
    if (s.contains('e+')) {
      final p = s.split('e+');
      final exp = int.parse(p[1]);
      final parts = p[0].split('.');
      final dec = parts.length > 1 ? parts[1] : '';
      if (exp >= dec.length) {
        s = parts[0] + dec + ('0' * (exp - dec.length));
      } else {
        s = '${parts[0]}${dec.substring(0, exp)}.${dec.substring(exp)}';
      }
      return s.replaceAll('.', ',');
    }

    if (v == v.truncateToDouble()) {
      return v.truncate().toString();
    }
    s = v.toStringAsFixed(4);
    s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    return s.replaceAll('.', ',');
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasil = null);
      return;
    }

    final isAllInt = _fields.every((f) {
      final t = f.controller.text.trim();
      return !t.contains(',') && !t.contains('.');
    });

    String strJumlah;
    String strKurang;
    String strKali;

    if (isAllInt) {
      final bValues = _fields.map((f) => BigInt.parse(f.controller.text.trim())).toList();
      strJumlah = bValues.reduce((a, b) => a + b).toString();
      strKurang = bValues.reduce((a, b) => a - b).toString();
      strKali = bValues.reduce((a, b) => a * b).toString();
    } else {
      final dValues = _fields.map((f) => _parse(f.controller.text)!).toList();
      strJumlah = _fmt(dValues.reduce((a, b) => a + b));
      strKurang = _fmt(dValues.reduce((a, b) => a - b));
      strKali = _fmt(dValues.reduce((a, b) => a * b));
    }

    final dValues = _fields.map((f) => _parse(f.controller.text)!).toList();
    String bagi;
    double berjalan = dValues.first;
    int? langkahNol;
    for (var i = 1; i < dValues.length; i++) {
      if (dValues[i] == 0) {
        langkahNol = i + 1;
        break;
      }
      berjalan = berjalan / dValues[i];
    }
    bagi = langkahNol != null
        ? 'tidak terdefinisi (angka ke-$langkahNol adalah nol)'
        : _fmt(berjalan);

    setState(() {
      _hasil = 'Total Penjumlahan = $strJumlah\n'
          'Total Pengurangan = $strKurang\n'
          'Total Perkalian   = $strKali\n'
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
                              inputFormatters: [_SingleDecimalSeparatorInputFormatter()],
                              decoration: InputDecoration(
                                labelText: 'Angka ke-${i + 1}',
                                hintText: 'Misal: 10 atau 2,5',
                                prefixIcon: const Icon(Icons.tag_rounded, size: 19),
                                counterText: '',
                              ),
                              maxLength: 18,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Wajib diisi';
                                }
                                if (_parse(v) == null) {
                                  return 'Harus berupa angka valid';
                                }
                                if (v.trim().replaceAll(RegExp(r'[,.-]'), '').length > 15) {
                                  return 'Maksimal 15 digit angka';
                                }
                                return null;
                              },
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