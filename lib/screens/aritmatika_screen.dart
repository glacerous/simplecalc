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
    if (double.tryParse(value.trim()) == null) {
      return 'Harus berupa angka';
    }
    return null;
  }

  void _hitung() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasil = null);
      return;
    }

    final a = double.parse(_aController.text.trim());
    final b = double.parse(_bController.text.trim());

    final pembagian = b != 0
        ? (a / b).toString()
        : 'tidak terdefinisi (pembagian dengan nol)';

    setState(() {
      _hasil = '$a + $b = ${a + b}\n'
          '$a - $b = ${a - b}\n'
          '$a * $b = ${a * b}\n'
          '$a / $b = $pembagian';
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
