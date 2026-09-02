import 'package:flutter/material.dart';

class GanjilGenapScreen extends StatefulWidget {
  const GanjilGenapScreen({super.key});

  @override
  State<GanjilGenapScreen> createState() => _GanjilGenapScreenState();
}

class _GanjilGenapScreenState extends State<GanjilGenapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController();

  String? _hasil;

  @override
  void dispose() {
    _nController.dispose();
    super.dispose();
  }

  void _cek() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasil = null);
      return;
    }

    final n = int.parse(_nController.text.trim());
    // Operator % di Dart selalu non-negatif untuk pembagi positif,
    // jadi logika ini tetap benar walau n negatif (mis. -4 % 2 == 0).
    final genap = n % 2 == 0;

    setState(() {
      _hasil = '$n adalah bilangan ${genap ? 'GENAP' : 'GANJIL'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganjil / Genap')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nController,
                keyboardType: const TextInputType.numberWithOptions(signed: true),
                decoration: const InputDecoration(
                  labelText: 'Masukkan bilangan bulat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Wajib diisi';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'Harus berupa bilangan bulat (tanpa koma/desimal)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cek,
                child: const Text('Cek'),
              ),
              const SizedBox(height: 24),
              if (_hasil != null)
                Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _hasil!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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
