import 'package:flutter/material.dart';

class GanjilGenapScreen extends StatefulWidget {
  const GanjilGenapScreen({super.key});

  @override
  State<GanjilGenapScreen> createState() => _GanjilGenapScreenState();
}

class _GanjilGenapScreenState extends State<GanjilGenapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  String? _hasil;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cek() {
    if (!_formKey.currentState!.validate()) {
      setState(() => _hasil = null);
      return;
    }

    final n = BigInt.parse(_controller.text.trim());
    setState(() {
      _hasil = '$n adalah bilangan ${n.isEven ? 'GENAP' : 'GANJIL'}';
    });
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Ganjil / Genap')),
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
                      'PARITAS BILANGAN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4.0,
                        color: ink.withValues(alpha: 0.45),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cek Ganjil atau Genap',
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
                      keyboardType: const TextInputType.numberWithOptions(signed: true),
                      decoration: const InputDecoration(
                        labelText: 'Masukkan bilangan bulat',
                        hintText: 'Contoh: 7, 12, atau -4',
                        prefixIcon: Icon(Icons.tag_rounded, size: 19),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                        if (BigInt.tryParse(v.trim()) == null) return 'Harus bilangan bulat';
                        return null;
                      },
                    ),
                    const SizedBox(height: 36),

                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _cek,
                        child: const Text('CEK BILANGAN'),
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
                          children: [
                            Text(
                              'HASIL PENGECEKAN',
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
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'InstrumentSerif',
                                fontSize: 26,
                                color: ink,
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
