import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/api_service.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';

class ListScreen extends StatefulWidget {
  final String category; // Menerima 'articles', 'blogs', atau 'reports'
  final String title; // Judul untuk ditampilkan di AppBar

  const ListScreen({super.key, required this.category, required this.title});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Article>> _futureData;

  // Variabel state untuk menyimpan author mana yang sedang dipilih pada Chip Filter.
  // Jika kosong (''), berarti tampilkan semua data tanpa filter.
  String selectedAuthor = '';

  @override
  void initState() {
    super.initState();
    // Memanggil API satu kali saat halaman pertama kali dibuka
    _futureData = ApiService.fetchData(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen()),
              );
            },
          ),
        ],
      ),
      // FutureBuilder otomatis menangani 3 kondisi proses pengambilan data dari internet:
      // 1. Loading (waiting), 2. Error, 3. Data Berhasil Didapat (hasData)
      body: FutureBuilder<List<Article>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi Kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          // Data asli dari API
          List<Article> allArticles = snapshot.data!;

          // FITUR FILTER (Ketentuan Soal No. 5):
          // Mengambil daftar nama author unik menggunakan .toSet() agar tidak ada nama ganda di Chip
          List<String> uniqueAuthors = allArticles
              .map((e) => e.newsSite)
              .toSet()
              .toList();

          // Menyaring daftar artikel jika user sedang mengaktifkan salah satu chip author
          List<Article> filteredArticles = selectedAuthor.isEmpty
              ? allArticles
              : allArticles
                    .where((article) => article.newsSite == selectedAuthor)
                    .toList();

          return Column(
            children: [
              // Barisan Chip Filter horizontal yang bisa digeser ke samping
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: uniqueAuthors.map((author) {
                    final bool isSelected = selectedAuthor == author;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(author),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            // Jika chip yang sama diklik lagi, reset filter (tampilkan semua)
                            selectedAuthor = selected ? author : '';
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Daftar Artikel hasil filter
              Expanded(
                child: ListView.builder(
                  itemCount: filteredArticles.length,
                  itemBuilder: (context, index) {
                    final item = filteredArticles[index];

                    // Sinkronisasi status favorit dengan list global sebelum ditampilkan
                    item.isFavorite = globalFavorites.any(
                      (fav) => fav.id == item.id,
                    );

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        // Ketentuan Soal No. 3:
                        // Menampilkan gambar thumbnail sebagai leading + EXCEPTION HANDLING jika gambar gagal dimuat
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl,
                            width: 75,
                            height: 75,
                            fit: BoxFit.cover,
                            // errorBuilder menangkap error HTTP/404 pada gambar agar UI tidak crash
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 75,
                                height: 75,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                        // Wajib menampilkan judul
                        title: Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Wajib menampilkan author
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(item.newsSite),
                        ),
                        onTap: () {
                          // Pindah ke halaman Detail sambil membawa data objek 'item'
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(article: item),
                            ),
                          ).then(
                            (_) => setState(() {}),
                          ); // Refresh state saat kembali dari Detail
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
