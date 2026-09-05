import 'package:flutter/material.dart';
import '../widgets/sky_video_bg.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _validUser = 'admin';
  static const _validPass = '12345';

  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    if (_userController.text.trim() == _validUser &&
        _passController.text.trim() == _validPass) {
      setState(() => _error = null);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    } else {
      setState(() => _error = 'Username atau password salah');
    }
  }

  InputDecoration _inputDeco(String hint, IconData icon, [Widget? suffix]) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 19, color: const Color(0xB3141D2B)),
      prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0x73141D2B)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF141D2B), width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: SkyBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'TUGAS MOBILE TEORI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4.5,
                            color: ink.withValues(alpha: 0.50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'simplecalc',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'InstrumentSerif',
                            fontSize: 84,
                            color: ink,
                            height: 0.95,
                          ),
                        ),
                        const SizedBox(height: 52),

                        TextFormField(
                          controller: _userController,
                          cursorColor: ink,
                          style: const TextStyle(fontSize: 15, color: ink),
                          decoration: _inputDeco('Username', Icons.mail_outline_rounded),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Username tidak boleh kosong' : null,
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _passController,
                          obscureText: _obscure,
                          cursorColor: ink,
                          style: const TextStyle(fontSize: 15, color: ink),
                          decoration: _inputDeco(
                            'Password',
                            Icons.lock_outline_rounded,
                            IconButton(
                              icon: Icon(
                                _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                size: 19,
                                color: const Color(0x99141D2B),
                              ),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Password tidak boleh kosong' : null,
                        ),

                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.red.shade800, fontWeight: FontWeight.w600),
                          ),
                        ],

                        const SizedBox(height: 44),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _login,
                            child: const Text('LOG IN'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
