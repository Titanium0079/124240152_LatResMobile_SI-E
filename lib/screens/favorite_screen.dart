import 'package:flutter/material.dart';

import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite')),
      // Mengecek apakah daftar favorit masih kosong atau sudah terisi
      body: globalFavorites.isEmpty
          ? const Center(child: Text('Belum ada data yang difavoritkan.'))
          : ListView.builder(
              itemCount: globalFavorites.length,
              itemBuilder: (context, index) {
                final item = globalFavorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 65,
                        height: 65,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                    title: Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(item.newsSite),
                    // Ketentuan Soal No. 4: List data favorit terupdate baik dihapus dari halaman
                    // Favorite langsung maupun diubah dari halaman Detail
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          item.isFavorite = false;
                          globalFavorites.removeAt(index);
                        });
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(article: item),
                        ),
                      ).then((_) {
                        // setState otomatis memperbarui tampilan jika status favorit diubah di DetailScreen
                        setState(() {});
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
