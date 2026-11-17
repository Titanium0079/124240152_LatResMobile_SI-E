import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk menangkap teks yang diketik user pada kolom input
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  // Fungsi untuk menyimpan username dan password baru ke memori lokal HP (SharedPreferences)
  Future<void> _register() async {
    // Validasi sederhana agar user tidak mendaftarkan input kosong
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username dan password tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Membuka akses penyimpanan lokal SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Menyimpan data dengan pasangan Key-Value
    await prefs.setString('username', _userController.text);
    await prefs.setString('password', _passController.text);

    if (!mounted) return;
    // Tampilkan notifikasi sukses dan kembali ke halaman Login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pendaftaran berhasil! Silakan login.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(
      context,
    ); // Menutup halaman Register dan kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Daftar Akun Baru',
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
              obscureText:
                  true, // Menyembunyikan karakter password menjadi titik-titik
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text('Daftar')),
          ],
        ),
      ),
    );
  }
}
