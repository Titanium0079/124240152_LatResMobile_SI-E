/// Halaman utama setelah pengguna berhasil login.
///
/// Menyediakan navigasi ke kategori News, Blog, Reports, halaman Favorite,
/// serta fungsi logout untuk mengakhiri sesi login lokal.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'list_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  /// Menghapus status sesi login di SharedPreferences dan mengarahkan user kembali ke LoginScreen
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Reset status login

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Ketentuan Soal No. 2: AppBar menampilkan username yang digunakan untuk login
        title: Text('Hai, $username!'),
        actions: [
          // Tombol pintas menuju halaman daftar item yang difavoritkan
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            tooltip: 'Lihat Favorite',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // MENU 1: NEWS -> Mengirim parameter category: 'articles'
            _buildMenuCard(
              context: context,
              icon: Icons.newspaper,
              title: 'News',
              subtitle: 'Get an overview of the latest SpaceFlight news, from various sources!',
              category: 'articles',
            ),
            const SizedBox(height: 12),

            // MENU 2: BLOG -> Mengirim parameter category: 'blogs'
            _buildMenuCard(
              context: context,
              icon: Icons.article_outlined,
              title: 'Blog',
              subtitle: 'Blogs often provide a more detailed overview of launches and missions.',
              category: 'blogs',
            ),
            const SizedBox(height: 12),

            // MENU 3: REPORTS -> Mengirim parameter category: 'reports'
            _buildMenuCard(
              context: context,
              icon: Icons.analytics_outlined,
              title: 'Reports',
              subtitle:
                  'Space stations and other missions often publish their data.',
              category: 'reports',
            ),

            const Spacer(), // Mendorong tombol Log Out agar berada di paling bawah layar
            // Ketentuan Soal No. 2: Terdapat tombol logout di bawah pilihan yang tersedia
            SizedBox(
              width: 160,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _logout(context),
                child: const Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper Widget agar kode pembuatan 3 kartu menu lebih bersih dan tidak berulang
  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String category,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 40, color: Colors.indigo),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: () {
          // Membuka ListScreen sambil membawa jenis kategori API yang diklik
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListScreen(category: category, title: title),
            ),
          );
        },
      ),
    );
  }
}
