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

  // Validator dipakai berulang untuk kedua field, jadi ditarik jadi satu fungsi.
  // Ini pengganti try-catch di versi console: TextFormField menampilkan
  // pesan error langsung di bawah kolom, tanpa program harus "menangkap" exception.
  String? _validateAngka(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Wajib diisi';
    }
    if (_parseAngka(value) == null) {
      return 'Harus berupa angka';
    }
    return null;
  }

  // Dart cuma ngenalin titik (.) sebagai pemisah desimal, sedangkan di Indonesia
  // orang sering pakai koma (,). Jadi sebelum di-parse, koma diganti dulu jadi titik.
  double? _parseAngka(String value) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  // Kebalikan dari _parseAngka: dipakai saat MENAMPILKAN angka ke user,
  // supaya hasil perhitungan juga muncul dengan format koma (gaya Indonesia),
  // bukan format titik bawaan Dart.
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
    return Scaffold(
      appBar: AppBar(title: const Text('Aritmatika')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _aController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Angka pertama',
                  helperText: 'Boleh pakai titik (.) atau koma (,)',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAngka,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Angka kedua',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAngka,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _hitung,
                child: const Text('Hitung'),
              ),
              const SizedBox(height: 24),
              if (_hasil != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _hasil!,
                      style: const TextStyle(fontSize: 16, height: 1.6),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
