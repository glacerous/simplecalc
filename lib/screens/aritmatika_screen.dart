import 'package:flutter/material.dart';

class AritmatikaScreen extends StatefulWidget {
  const AritmatikaScreen({super.key});

  @override
  State<AritmatikaScreen> createState() => _AritmatikaScreenState();
}

class _AritmatikaScreenState extends State<AritmatikaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();

  String? _hasil;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  String? _validateAngka(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Wajib diisi';
    }
    if (_parseAngka(value) == null) {
      return 'Harus berupa angka';
    }
    return null;
  }

  double? _parseAngka(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  String _formatAngka(double value) {
    return value.toString().replaceAll('.', ',');
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasil = null);
      return;
    }

    final a = _parseAngka(_aController.text)!;
    final b = _parseAngka(_bController.text)!;

    final pembagian = b != 0
        ? _formatAngka(a / b)
        : 'tidak terdefinisi (pembagian dengan nol)';

    setState(() {
      _hasil = '${_formatAngka(a)} + ${_formatAngka(b)} = ${_formatAngka(a + b)}\n'
          '${_formatAngka(a)} - ${_formatAngka(b)} = ${_formatAngka(a - b)}\n'
          '${_formatAngka(a)} * ${_formatAngka(b)} = ${_formatAngka(a * b)}\n'
          '${_formatAngka(a)} / ${_formatAngka(b)} = $pembagian';
    });
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Aritmatika'),
      ),
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
                        fontWeight: FontWeight.w400,
                        color: ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _aController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: ink,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Angka pertama',
                        hintText: 'Masukkan angka (mis. 10 atau 2,5)',
                        helperText: 'Boleh menggunakan titik (.) atau koma (,)',
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: ink.withValues(alpha: 0.45),
                        ),
                        prefixIcon: Icon(
                          Icons.tag_rounded,
                          size: 19,
                          color: ink.withValues(alpha: 0.70),
                        ),
                      ),
                      validator: _validateAngka,
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _bController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: ink,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Angka kedua',
                        hintText: 'Masukkan angka',
                        prefixIcon: Icon(
                          Icons.tag_rounded,
                          size: 19,
                          color: ink.withValues(alpha: 0.70),
                        ),
                      ),
                      validator: _validateAngka,
                    ),
                    const SizedBox(height: 36),

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
                          border: Border.all(
                            color: ink.withValues(alpha: 0.16),
                            width: 1.0,
                          ),
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
                            Divider(
                              color: ink.withValues(alpha: 0.10),
                              thickness: 0.8,
                              height: 1,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _hasil!,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.8,
                                color: ink,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.4,
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
