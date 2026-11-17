class Article {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite; // Berperan sebagai author
  final String summary;
  final String publishedAt;
  bool isFavorite; // Status lokal, BUKAN dari API

  Article({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: (json['title'] ?? '') as String,
      url: (json['url'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String, // snake_case
      newsSite: (json['news_site'] ?? '') as String,
      summary: (json['summary'] ?? '') as String,
      publishedAt: (json['published_at'] ?? '') as String, // snake_case
      // isFavorite tidak ada di API, jadi tidak diambil dari JSON
    );
  }
}
