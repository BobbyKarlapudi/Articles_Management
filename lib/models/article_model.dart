class Article {
  final String id, title, author, category, description;
  final int readTime;
  final DateTime createdAt, updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.readTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      category: json['category'],
      description: json['description'],
      readTime: json['read_time'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static List<Article> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Article.fromJson(json)).toList();
  }
}
