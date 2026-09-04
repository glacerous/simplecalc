import 'package:flutter/material.dart';

class JumlahTotalScreen extends StatefulWidget {
  const JumlahTotalScreen({super.key});

  @override
  State<JumlahTotalScreen> createState() => _JumlahTotalScreenState();
}

class _JumlahTotalScreenState extends State<JumlahTotalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  int? _banyakDigit;
  int? _total;
  String? _rincian;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _banyakDigit = null;
        _total = null;
        _rincian = null;
      });
      return;
    }

    final digits = _controller.text.trim().split('').map(int.parse).toList();
    setState(() {
      _banyakDigit = digits.length;
      _total = digits.reduce((a, b) => a + b);
      _rincian = digits.join(' + ');
    });
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Jumlah Total Angka')),
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
                      'TOTAL ANGKA DALAM 1 FIELD',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4.0,
                        color: ink.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Hitung Total Angka',
                      style: TextStyle(
                        fontFamily: 'InstrumentSerif',
                        fontSize: 34,
                        color: ink,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Masukkan deretan angka',
                        hintText: 'Contoh: 12345',
                        prefixIcon: Icon(Icons.pin_rounded, size: 19),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                        if (!RegExp(r'^[0-9]+$').hasMatch(v.trim())) {
                          return 'Hanya boleh berisi angka (0-9)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 36),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _hitung,
                        child: const Text('HITUNG TOTAL'),
                      ),
                    ),
                    const SizedBox(height: 28),

                    if (_total != null)
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
                              'HASIL ANALISIS',
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
                              'Banyaknya angka: $_banyakDigit digit',
                              style: const TextStyle(fontSize: 15, color: ink),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Penjumlahan: $_rincian = $_total',
                              style: const TextStyle(
                                fontSize: 16,
                                color: ink,
                                fontWeight: FontWeight.w600,
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
