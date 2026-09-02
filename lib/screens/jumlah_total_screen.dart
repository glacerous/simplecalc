import 'package:flutter/material.dart';

class JumlahTotalScreen extends StatefulWidget {
  const JumlahTotalScreen({super.key});

  @override
  State<JumlahTotalScreen> createState() => _JumlahTotalScreenState();
}

class _JumlahTotalScreenState extends State<JumlahTotalScreen> {
  // ===== Tahap 1: minta banyaknya data =====
  final _jumlahFormKey = GlobalKey<FormState>();
  final _jumlahController = TextEditingController();

  // ===== Tahap 2: input tiap angka =====
  final _dataFormKey = GlobalKey<FormState>();
  List<TextEditingController> _angkaControllers = [];

  int? _banyakData; // null = masih di tahap 1
  double? _total;

  @override
  void dispose() {
    _jumlahController.dispose();
    for (final c in _angkaControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _lanjutKeInputAngka() {
    if (!_jumlahFormKey.currentState!.validate()) return;

    final n = int.parse(_jumlahController.text.trim());

    // Bersihkan controller lama kalau user ulang dari awal
    for (final c in _angkaControllers) {
      c.dispose();
    }

    setState(() {
      _banyakData = n;
      _angkaControllers = List.generate(n, (_) => TextEditingController());
      _total = null;
    });
  }

  void _hitungTotal() {
    if (!_dataFormKey.currentState!.validate()) return;

    double total = 0;
    for (final c in _angkaControllers) {
      total += double.parse(c.text.trim());
    }

    setState(() => _total = total);
  }

  void _ulangiDariAwal() {
    for (final c in _angkaControllers) {
      c.dispose();
    }
    setState(() {
      _banyakData = null;
      _angkaControllers = [];
      _total = null;
      _jumlahController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jumlah Total Angka')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _banyakData == null ? _buildTahap1() : _buildTahap2(),
      ),
    );
  }

  Widget _buildTahap1() {
    return Form(
      key: _jumlahFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _jumlahController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Banyaknya data',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Wajib diisi';
              }
              final n = int.tryParse(value.trim());
              if (n == null) {
                return 'Harus berupa bilangan bulat';
              }
              if (n <= 0) {
                return 'Banyaknya data harus lebih dari 0';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _lanjutKeInputAngka,
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  Widget _buildTahap2() {
    return Form(
      key: _dataFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _banyakData!,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return TextFormField(
                  controller: _angkaControllers[index],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Angka ke-${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Wajib diisi';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Harus berupa angka';
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          if (_total != null)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Jumlah total dari $_banyakData angka adalah: $_total',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _ulangiDariAwal,
                  child: const Text('Ulangi'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _hitungTotal,
                  child: const Text('Hitung Total'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
