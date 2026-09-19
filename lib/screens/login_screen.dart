import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../helpers/session_manager.dart';
import '../theme/app_theme.dart';
import 'main_shell_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController(text: 'admin');
  final _passController = TextEditingController(text: 'admin123');
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final u = _userController.text.trim();
    final p = _passController.text.trim();

    if (u.isEmpty || p.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username dan Password wajib diisi')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await DatabaseHelper.instance.login(u, p);
      if (!mounted) return;

      if (success) {
        await SessionManager.saveLogin(u);
        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShellScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Username atau password salah!')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.paper,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppTheme.snow,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppTheme.cloud),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: AppTheme.cobalt, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.computer_rounded, size: 32, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('WARNET POJOK', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: AppTheme.obsidian)),
                  const SizedBox(height: 4),
                  const Text('Masuk untuk mengakses sistem kasir & operasional', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.fog, fontSize: 13)),
                  const SizedBox(height: 28),
                  TextField(controller: _userController, decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline, size: 20))),
                  const SizedBox(height: 14),
                  TextField(controller: _passController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline, size: 20))),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.obsidian, foregroundColor: Colors.white),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('LOGIN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Default: admin / admin123', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.fog, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
