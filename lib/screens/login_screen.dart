import 'package:flutter/material.dart';
import '../widgets/sky_video_bg.dart';
import 'menu_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Kredensial untuk login
  static const String _validUsername = 'admin';
  static const String _validPassword = '12345';

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == _validUsername && password == _validPassword) {
      setState(() => _errorMessage = null);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MenuScreen()),
      );
    } else {
      setState(() => _errorMessage = 'Username atau password salah');
    }
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF141D2B);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background video langit
          const Positioned.fill(
            child: SkyBackground(),
          ),

          // 2. Efek mist lembut di tengah untuk kontras teks
          Center(
            child: Container(
              width: 520,
              height: 520,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // 3. Form login
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
                            fontWeight: FontWeight.w400,
                            letterSpacing: -1.0,
                            color: ink,
                            height: 0.95,
                          ),
                        ),
                        const SizedBox(height: 52),

                        // Input Username
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontSize: 15,
                            color: ink,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                          cursorColor: ink,
                          cursorWidth: 1.2,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: ink.withValues(alpha: 0.45),
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.mail_outline_rounded,
                              size: 19,
                              color: ink.withValues(alpha: 0.70),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 13),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ink.withValues(alpha: 0.45),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ink, width: 1.6),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.shade700,
                                width: 1.0,
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.shade800,
                                width: 1.6,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Input Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            fontSize: 15,
                            color: ink,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                          cursorColor: ink,
                          cursorWidth: 1.2,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: ink.withValues(alpha: 0.45),
                              fontWeight: FontWeight.w400,
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              size: 19,
                              color: ink.withValues(alpha: 0.70),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 19,
                                color: ink.withValues(alpha: 0.60),
                              ),
                              onPressed: () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 13),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ink.withValues(alpha: 0.45),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: ink, width: 1.6),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.shade700,
                                width: 1.0,
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red.shade800,
                                width: 1.6,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            return null;
                          },
                        ),

                        // Pesan Error
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.red.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],

                        const SizedBox(height: 44),

                        // Tombol Login
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ink,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: ink.withValues(alpha: 0.28),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'LOG IN',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3.5,
                              ),
                            ),
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
