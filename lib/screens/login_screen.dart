/// Halaman autentikasi/login pengguna.
///
/// Memeriksa username dan password terhadap data yang tersimpan di
/// SharedPreferences. Jika cocok, status login disimpan dan pengguna
/// diarahkan ke halaman utama.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  /// Fungsi untuk memverifikasi kecocokan input login dengan data yang tersimpan di SharedPreferences
  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();

    // Mengambil data akun yang pernah didaftarkan sebelumnya
    String? savedUser = prefs.getString('username');
    String? savedPass = prefs.getString('password');

    // Mengecek apakah input cocok dan tidak kosong
    if (_userController.text.isNotEmpty &&
        _userController.text == savedUser &&
        _passController.text == savedPass) {
      // Simpan status 'isLoggedIn' = true agar saat aplikasi ditutup & dibuka lagi,
      // user langsung masuk ke HomeScreen tanpa perlu login ulang (Ketentuan Soal No. 1)
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('activeUser', _userController.text);

      if (!mounted) return;

      // pushReplacement mengganti halaman Login dengan HomeScreen (user tidak bisa tekan tombol Back ke Login)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(username: _userController.text),
        ),
      );
    } else {
      // Ketentuan Soal No. 1: Jika gagal login, wajib memunculkan SnackBar berwarna merah
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Login Gagal! Pastikan sudah Register atau cek password.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Silakan Login',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _userController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Login')),
            TextButton(
              onPressed: () {
                // Navigasi menuju halaman Register
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Belum punya akun? Daftar di sini'),
            ),
          ],
        ),
      ),
    );
  }
}
