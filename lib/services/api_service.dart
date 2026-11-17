import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/article_model.dart';

class ApiService {
  static Future<List<Article>> fetchData(String type) async {
    // type bisa berupa: 'articles' (untuk news), 'blogs', atau 'reports'
    final url = Uri.parse(
      'https://api.spaceflightnewsapi.net/v4/$type/?limit=30',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List results = data['results'];
      return results.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data (kode ${response.statusCode})');
    }
  }
}
