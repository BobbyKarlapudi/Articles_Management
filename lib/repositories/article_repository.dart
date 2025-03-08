import 'dart:convert';
import 'package:article_management/models/article_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://flutter.starbuzz.tech/articles";

  Future<List<Article>> fetchArticles({int page = 1, int size = 33}) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl?page=$page&size=$size"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Article.fromJsonList(data['data']['records']);
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception("Error fetching articles: ${e.toString()}");
    }
  }

  Future<Article> fetchArticleById(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"));

      if (response.statusCode == 200) {
        return Article.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception("Error fetching article: ${e.toString()}");
    }
  }

  Future<void> createArticle(Map<String, dynamic> articleData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(articleData),
      );

      if (response.statusCode != 201) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception("Error creating article: ${e.toString()}");
    }
  }

  Future<void> updateArticle(String id, Map<String, dynamic> updates) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updates),
      );

      if (response.statusCode != 200) {
        throw Exception(_handleError(response));
      }
    } catch (e) {
      throw Exception("Error updating article: ${e.toString()}");
    }
  }

  String _handleError(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      return errorData['message'] ?? "Unknown error occurred";
    } catch (_) {
      return "Unexpected error: ${response.statusCode}";
    }
  }
}
