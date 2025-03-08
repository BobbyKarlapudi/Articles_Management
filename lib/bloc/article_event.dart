import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchArticles extends ArticleEvent {
  final int page;
  final int size;

  FetchArticles({this.page = 1, this.size = 10});
}

class FetchArticleById extends ArticleEvent {
  final String id;
  FetchArticleById(this.id);
}

class CreateArticle extends ArticleEvent {
  final Map<String, dynamic> articleData;
  CreateArticle(this.articleData);
}

class UpdateArticle extends ArticleEvent {
  final String id;
  final Map<String, dynamic> updates;
  UpdateArticle(this.id, this.updates);
}
