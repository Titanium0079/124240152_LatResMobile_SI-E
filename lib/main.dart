/// Titik masuk (entry point) aplikasi SpaceFlight News.
///
/// File ini memeriksa status login yang tersimpan secara lokal, lalu
/// menentukan halaman pertama yang ditampilkan kepada pengguna.
/// `MyApp` mengatur tema global dan halaman awal aplikasi.
/// 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Wajib dipanggil sebelum mengakses SharedPreferences di dalam fungsi main()
  WidgetsFlutterBinding.ensureInitialized();

  // Mengecek apakah user masih memiliki sesi login aktif di HP
  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String activeUser = prefs.getString('activeUser') ?? 'User';

  runApp(MyApp(isLoggedIn: isLoggedIn, username: activeUser));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String username;

  const MyApp({super.key, required this.isLoggedIn, required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latihan Responsi PAM',
      // Pengaturan tema dominan Indigo dan Putih
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // Routing awal: Jika sudah login langsung ke HomeScreen, jika belum ke LoginScreen
      home: isLoggedIn ? HomeScreen(username: username) : const LoginScreen(),
    );
  }
}
