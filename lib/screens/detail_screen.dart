import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article_model.dart';

/// List penampung data favorit yang bersifat global (dapat diakses dari semua halaman).
/// Menyimpan artikel dari kategori News, Blog, maupun Report secara bersamaan.
List<Article> globalFavorites = [];

class DetailScreen extends StatefulWidget {
  final Article article;
  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    // Pastikan ikon hati langsung sesuai dengan status di globalFavorites saat halaman dibuka
    widget.article.isFavorite = globalFavorites.any(
      (item) => item.id == widget.article.id,
    );
  }

  /// Ketentuan Soal No. 6: Membuka URL situs resmi berita di browser eksternal
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka tautan: $urlString')),
      );
    }
  }

  /// Ketentuan Soal No. 4 & 6: Menambah atau menghapus data dari daftar favorit
  void _toggleFavorite() {
    setState(() {
      bool exists = globalFavorites.any((item) => item.id == widget.article.id);

      if (!exists) {
        widget.article.isFavorite = true;
        globalFavorites.add(widget.article);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ditambahkan ke favorite')),
        );
      } else {
        widget.article.isFavorite = false;
        globalFavorites.removeWhere((item) => item.id == widget.article.id);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Dihapus dari favorite')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          // Tombol toggle Favorite di pojok kanan atas AppBar
          IconButton(
            icon: Icon(
              widget.article.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.article.isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Wajib menampilkan gambar (lengkap dengan errorBuilder)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.article.imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 60),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. Wajib menampilkan judul data
            Text(
              widget.article.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 3. Wajib menampilkan author data
            Text(
              widget.article.newsSite,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 4),

            // 4. Wajib menampilkan tanggal publish
            Text(
              widget.article.publishedAt,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const Divider(height: 24),

            // 5. Wajib menampilkan summary data
            Text(
              widget.article.summary,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),

            // 6. Tombol yang mengarahkan (launch url) ke situs resmi berita
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(widget.article.url),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Buka Web'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
